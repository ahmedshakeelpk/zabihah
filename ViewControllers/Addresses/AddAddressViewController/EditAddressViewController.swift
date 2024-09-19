//
//  EditAddressViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class EditAddressViewController: UIViewController {
    @IBOutlet weak var buttonGps: UIButton!
    @IBOutlet weak var viewButtonGpsBackGround: UIView!
    
    @IBOutlet weak var labelButtonSaveAsNew: UILabel!
    @IBOutlet weak var viewAddressMainBackGround: UIView!
    @IBOutlet weak var viewButtonsBackGround: UIView!
    @IBOutlet weak var viewButtonEditBackGround: UIView!
    @IBOutlet weak var viewButtonContinueBackGround: ViewButtonSetting!
    
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonSaveAsNew: UIButton!
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
            mapView.delegate = self
        }
    }
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonEditAddress: UIButton!
    @IBOutlet weak var viewAddressSubBackGround: UIView!
    @IBOutlet weak var stackViewAddressBackGround: UIView!
    @IBOutlet weak var viewButtonSaveAsNewBackGround: UIView!
    @IBOutlet weak var stackViewSearchBackGround: UIStackView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewButtonBackBackGround: UIView!
    @IBOutlet weak var labelAddressTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonShowSavedAddresses: UIButton!
    
    var isFromAddressList = false
    var isFromAddressListAddNewButton = false
    var addressFromPreviousScreen = ""
    var disableTimerCount: Double? = 1.5
    var isDisableUpdateLocation: Bool? = false {
        didSet {
            if isDisableUpdateLocation == true {
                Timer.scheduledTimer(withTimeInterval: disableTimerCount!, repeats: false) { timer in
                    self.isDisableUpdateLocation = false
                    self.disableTimerCount = 1.5
                }
            }
        }
    }
    var locationManager = CLLocationManager()
    var buttonContinueHandler: ((String, CLLocationCoordinate2D?) -> ())!
    
    var userLocationFromEditModel: CLLocation!
    
    var modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData? {
        didSet {
//            disableTimerCount = 3
            if isDisableUpdateLocation != true && isFromAddressListAddNewButton != true {
                isDisableUpdateLocation = true
            }
            if userLocationFromEditModel == nil {
                userLocationFromEditModel = CLLocation(latitude: modelUserAddressesResponseData?.latitude ?? 0.0, longitude: modelUserAddressesResponseData?.longitude ?? 0.0)
            }
        }
    }
    
    
    var userOldLocation: CLLocationCoordinate2D?
    var isEditAddress: Bool! = false
    var location: CLLocationCoordinate2D? {
        didSet {
            if userOldLocation == nil {
                userOldLocation = location
            }
            if modelUserAddressesResponseData != nil {
                modelUserAddressesResponseData?.latitude = location?.latitude
                modelUserAddressesResponseData?.longitude = location?.longitude
            }
            DispatchQueue.main.async {
                self.calculateNewAndOldLatititudeLongitude()
            }
        }
    }
    var defaultAddressIndex: Int? = 0
    var modelGetUserAddressResponse: AddressesListViewController.ModelGetUserAddressResponse? {
        didSet {
            if modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0 > 0 {
                if let defaultAddressIndex = modelGetUserAddressResponse?.userAddressesResponseData?.firstIndex(where: { model in
                    model.isDefault ?? false
                }) {
                    self.defaultAddressIndex = defaultAddressIndex
                    if let modelRecord = modelGetUserAddressResponse?.userAddressesResponseData?[defaultAddressIndex] {
                        modelUserAddressesResponseData = modelRecord
                        
                        setAddress(addressTitle: modelRecord.name ?? "", formattedAddress: modelRecord.physicalAddress ?? "")
                        setZoom(latitude: modelRecord.latitude, longitude: modelRecord.longitude)
                        location = CLLocationCoordinate2D(latitude: modelRecord.latitude!, longitude: modelRecord.longitude!)
                    }
                }
            }
        }
    }
    var modelEditUserAddressResponse: ModelEditUserAddressResponse? {
        didSet {
            if modelEditUserAddressResponse?.status == 500 {
                
            }
            else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewButtonEditBackGround.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.locationConfiguration()
        }
        drawCircleForRadiusForGoogleMap()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        viewButtonGpsBackGround.circle()
        viewButtonBackBackGround.radius(radius: 8)
        viewAddressSubBackGround.radius(radius: 8)
        stackViewSearchBackGround.radius(radius: 8)
        stackViewAddressBackGround.radius(radius: 8)
        viewButtonSaveAsNewBackGround.radius(color: .clrLightGray, borderWidth: 1)
        //        setZoom()
        //        setAddress()
        
        if modelUserAddressesResponseData != nil {
            self.setAddress(addressTitle: modelUserAddressesResponseData?.name, formattedAddress: modelUserAddressesResponseData?.physicalAddress)
            self.setZoom(latitude: modelUserAddressesResponseData?.latitude, longitude: modelUserAddressesResponseData?.longitude)
            self.location = CLLocationCoordinate2D(latitude: modelUserAddressesResponseData?.latitude ?? 0, longitude: modelUserAddressesResponseData?.longitude ?? 0)
            //            labelButtonSaveAsNew.textColor = .lightGray
            //            buttonSaveAsNew.isUserInteractionEnabled = false
            //            buttonContinue.isUserInteractionEnabled = false
            //            viewButtonContinueBackGround.backgroundColor = .lightGray
        }
        else {
            if isFromAddressList {
                buttonContinue.isUserInteractionEnabled = false
                viewButtonContinueBackGround.backgroundColor = .lightGray
                viewButtonEditBackGround.isHidden = false
                if kUserCurrentLocation != nil {
                    location = CLLocationCoordinate2D(latitude: kUserCurrentLocation.coordinate.latitude, longitude: kUserCurrentLocation.coordinate.longitude)
                }
            }
            self.setAddress(formattedAddress: addressFromPreviousScreen)
            if location != nil {
                self.setZoom(latitude: location?.latitude, longitude: location?.longitude)
            }
        }
        checkLocationServices()
    }
    
    func checkLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            // Location access is granted
            break
        case .denied:
            showLocationDisabledAlert(viewController: self)
        case .notDetermined:
            // Request permission
            showLocationDisabledAlert(viewController: self)
        case .restricted:
            showLocationDisabledAlert(viewController: self)
        @unknown default:
            break
        }
    }
    
    @IBAction func buttonGps(_ sender: Any) {
        gpsButtonTapped()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.gpsButtonTapped()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.gpsButtonTapped()
//            }
//
//        }
    }
    
    @objc func gpsButtonTapped() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
//        guard let location2 = mapView.myLocation else { return }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            guard let location = self.mapView.myLocation else { return }
//            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
//            self.mapView.animate(to: camera)
//        }
    }
    func locationConfiguration() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.isMyLocationEnabled = true
    }
    
    @IBAction func buttonShowSavedAddresses(_ sender: Any) {
        navigateToAddressesListViewController()
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
        
    }
    @IBAction func buttonSearch(_ sender: Any) {
        autocompleteClicked()
    }
    
    @IBAction func buttonContinue(_ sender: Any) {
        //        if textFieldSearch.text == "" {
        //            showToast(message: "Search address then you will be able to save it")
        //            return()
        //        }
        if location != nil {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    if controller is HomeViewController {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.buttonContinueHandler?(self.labelAddressTitle.text!, self.location!)
                        }
                        self.navigationController!.popToViewController(controller, animated: true)
                    }
                    break
                }
            }
        }
    }
    
    @IBAction func buttonSaveAsNew(_ sender: Any) {
        if location != nil {
            if modelUserAddressesResponseData == nil {
                self.navigateToAddAddressViewController()
            }
            else {
                navigateToAddAddressViewControllerFromEditButton()
            }
        }
    }
    
    @IBAction func buttonEditAddress(_ sender: Any) {
        navigateToAddAddressViewControllerFromEditButton()
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.modelUserAddressesResponseData = modelUserAddressesResponseData
        vc.newAddressAddedHandler = { (address, location) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.popViewController(animated: true)
                self.buttonContinueHandler?(address, location)
            }
        }
        vc.newAddress = labelAddress.text!
        vc.location = location
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddressesListViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddressesListViewController") as! AddressesListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddAddressViewControllerFromEditButton() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.location = self.location
        if modelUserAddressesResponseData == nil {
            vc.newAddress = labelAddress.text!
            vc.location = self.location
        }
        vc.isEditAddress = true
        vc.modelUserAddressesResponseData = modelUserAddressesResponseData
        vc.addressEditHandler = { location in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.popViewController(animated: false)
                self.buttonContinueHandler?(self.labelAddress.text!, self.location!)
            }
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setZoom(latitude: Double? = 47.07903, longitude: Double? = -122.961283) {
        if mapView == nil {
            return()
        }
        let lat = latitude!
        let long = longitude!
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    func setMarker(latitude: Double? = 47.07903, longitude: Double? = -122.961283) {
        let lat = latitude!
        let long = longitude!
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.map = self.mapView
    }
    
    func setAddress(addressTitle: String? = "", formattedAddress: String? = "") {
        //        labelAddressTitle.text = addressTitle
        labelAddress.text = formattedAddress
        modelUserAddressesResponseData?.name = addressTitle
        modelUserAddressesResponseData?.physicalAddress = formattedAddress
    }
    
    func getLocationCoordinateFromPlaceId(placeId: String) {
        // Define a Place ID.
        //        let placeID = placeId//"ChIJV4k8_9UodTERU5KXbkYpSYs"
        //
        //        var client = GMSPlacesClient()
        //        // Specify the place data types to return.
        //        let myProperties: [GMSPlaceProperty] = [.name, .website, .reviews]
        //
        //        // Create the GMSFetchPlaceRequest object.
        //        let fetchPlaceRequest = GMSFetchPlaceRequest(placeID: placeID, placeProperties: myProperties)
        //
        //        client.fetchPlaceWithRequest(fetchPlaceRequest: fetchPlaceRequest, callback: {
        //          (place: GMSPlace?, error: Error?) in
        //          if let error = error {
        //            print("An error occurred: \(error.localizedDescription)")
        //            return
        //          }
        //          if let place = place {
        //            let firstReview: GMSPlaceReview = place.reviews![0]
        //
        //            // Use firstReview to access review text, authorAttribution, and other fields.
        //
        //          }
        //        })
    }
    
    func getUserAddress() {
        APIs.postAPI(apiName: .editreview, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: AddressesListViewController.ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
    
    func drawCircleForRadiusForGoogleMap() {
        if kUserCurrentLocation == nil {
//            kUserCurrentLocation = CLLocation(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0)
            
            return()
        }
        let circleRadius = 0.250 * 1000 // 20 Km in meters
        let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(kUserCurrentLocation.coordinate.latitude, kUserCurrentLocation.coordinate.longitude);
        let circ = GMSCircle(position: circleCenter, radius: circleRadius)
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = .colorAppWithOccupacy10
        circ.strokeWidth = 1
        circ.map = self.mapView
    }
    
    func calculateNewAndOldLatititudeLongitude() {
        
        var myLocation: CLLocation?
        myLocation = CLLocation(latitude: kUserCurrentLocation.coordinate.latitude, longitude: kUserCurrentLocation.coordinate.longitude)
        if userOldLocation == nil {
            myLocation = CLLocation(latitude: kUserCurrentLocation.coordinate.latitude, longitude: kUserCurrentLocation.coordinate.longitude)
        }
        else {
//            myLocation = CLLocation(latitude: userOldLocation!.latitude, longitude: userOldLocation!.longitude)
        }
        
        //My Next Destination
        var myNextDestination = CLLocation(latitude: self.location?.latitude ?? 0, longitude: self.location?.longitude ?? 0)
        //Finding my distance to my next destination (in km)
        var distance = (myLocation?.distance(from: myNextDestination) ?? 0) / 1000
        if distance > 0.250 {
            labelAddressTitle?.text = labelAddress?.text!
        }
        else {
            labelAddressTitle?.text = "Searching around your current location     "
        }
        
        if modelUserAddressesResponseData != nil {
            buttonContinue.isUserInteractionEnabled = false
            viewButtonContinueBackGround.backgroundColor = .lightGray
            viewButtonEditBackGround.isHidden = false
            
            //My location
            myLocation = userLocationFromEditModel
            //My Next Destination
            myNextDestination = CLLocation(latitude: self.location?.latitude ?? 0, longitude: self.location?.longitude ?? 0)
            
            distance = (myLocation?.distance(from: myNextDestination) ?? 0) / 1000
            if distance > 0.250 {
                labelButtonSaveAsNew.textColor = .black
                buttonSaveAsNew.isUserInteractionEnabled = true
                labelButtonSaveAsNew.text = "Update"
            }
            else {
                labelButtonSaveAsNew.textColor = .lightGray
                buttonSaveAsNew.isUserInteractionEnabled = false
                labelButtonSaveAsNew.text = "Update"
            }
        }
    }
}

extension EditAddressViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("didTapMyLocationButton")
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        return false
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            print("dragged")
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if self.isDisableUpdateLocation! {
            return()
        }
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        DispatchQueue.main.async {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first else {
                    let errorString = error?.localizedDescription ?? "Unexpected Error"
                    print("Unable to reverse geocode the given location. Error: \(errorString)")
                    return
                }
                let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                print(reversedGeoLocation.formattedAddress)
                self.setAddress(addressTitle: "\(reversedGeoLocation.name) \(reversedGeoLocation.city)" , formattedAddress: reversedGeoLocation.formattedAddress)
                self.location = center
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
    }
}

extension EditAddressViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place coordinate: \(place.coordinate)")
        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")

//        textFieldSearch.text = place.name
        self.isDisableUpdateLocation = true
        self.setAddress(addressTitle: "\(place.name ?? "")" , formattedAddress: place.formattedAddress)
        self.setZoom(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.location = place.coordinate
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// Handle the user's selection.
extension EditAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        //    searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
}

extension EditAddressViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                // Request the appropriate authorization based on the needs of the app
                locationManager.requestWhenInUseAuthorization()
                // manager.requestAlwaysAuthorization()
            case .restricted:
                print("Sorry, restricted")
                // Optional: Offer to take user to app's settings screen
            case .denied:
                print("Sorry, denied")
                // Optional: Offer to take user to app's settings screen
            case .authorizedAlways, .authorizedWhenInUse:
                // The app has permission so start getting location updates
                manager.startUpdatingLocation()
            @unknown default:
                print("Unknown status")
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if isDisableUpdateLocation == true {
            return()
        }
        let location = locations.last! as CLLocation
        self.isDisableUpdateLocation = true
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            print(reversedGeoLocation.formattedAddress)
            
            self.setAddress(addressTitle: "\(reversedGeoLocation.name) \(reversedGeoLocation.city)" , formattedAddress: reversedGeoLocation.formattedAddress)
            self.setZoom(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = location.coordinate
            kUserCurrentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.locationManager.stopUpdatingLocation()
        }
    }
}

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US

//    var formattedAddress: String {
//        return """
//        \(name), 
//        \(streetNumber) \(streetName),
//        \(city), \(state) \(zipCode) \(country)
//        """
//    }
//    var formattedAddress: String {
//        return """
//        \(name), \(streetNumber) \(streetName), \(city), \(state) \(zipCode) \(country)
//        """
//    }
    var formattedAddress: String {
        return """
        \(tempSolutionForStreetName)\(streetNumber) \(streetName), \(city), \(state) \(zipCode) \(country)
        """
    }
    
    var tempSolutionForStreetName : String {
        let tempName = (name.lowercased()).replacingOccurrences(of: "\(streetNumber) \(streetName)".lowercased(), with: "")
        if tempName == "" {
            return ""
        }
        else {
            return tempName+", "
        }
    }

    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
