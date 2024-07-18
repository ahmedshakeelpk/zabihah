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

class  EditAddressViewController: UIViewController {
    
    @IBOutlet weak var labelButtonSaveAsNew: UILabel!
    @IBOutlet weak var viewAddressMainBackGround: UIView!
    @IBOutlet weak var viewButtonsBackGround: UIView!
    @IBOutlet weak var viewButtonEditBackGround: UIView!
    
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonSaveAsNew: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
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


    var locationManager = CLLocationManager()
    var buttonContinueHandler: ((CLLocationCoordinate2D?) -> ())!

    
    var modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData? {
        didSet {
        
        }
    }
    
    var location: CLLocationCoordinate2D? {
        didSet {
            if modelUserAddressesResponseData != nil {
                modelUserAddressesResponseData?.latitude = location?.latitude
                modelUserAddressesResponseData?.longitude = location?.longitude
            }
        }
    }
    var defaultAddressIndex: Int? = 0
    var modelGetUserAddressResponse: AddressesListViewController.ModelGetUserAddressResponse? {
        didSet {
            if modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0 > 0 {
//                if let defaultAddressIndex = modelGetUserAddressResponse?.userAddressesResponseData?.firstIndex(where: { model in
//                    model.isDefault ?? false
//                }) {
//                    self.defaultAddressIndex = defaultAddressIndex
//                }
            }
            else {
                viewButtonEditBackGround.isHidden = true
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
    
    @IBOutlet weak var viewButtonContinueBackGround: ViewButtonSetting!
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtonBackBackGround.radius(radius: 8)
        viewAddressSubBackGround.radius(radius: 8)
        stackViewSearchBackGround.radius(radius: 8)
        stackViewAddressBackGround.radius(radius: 8)
        viewButtonSaveAsNewBackGround.radius(color: .clrLightGray, borderWidth: 1)
        locationConfiguration()
        setZoom()
        setAddress()
        if modelUserAddressesResponseData != nil {
            self.setAddress(addressTitle: modelUserAddressesResponseData?.title, formattedAddress: modelUserAddressesResponseData?.address)
            self.setZoom(latitude: modelUserAddressesResponseData?.latitude, longitude: modelUserAddressesResponseData?.longitude)
            labelButtonSaveAsNew.textColor = .lightGray
            buttonSaveAsNew.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            viewButtonContinueBackGround.backgroundColor = .lightGray
        }
        else {
            getUserAddress()
        }
    }
    
    func locationConfiguration() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
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
        if textFieldSearch.text == "" {
            showToast(message: "Search address then you will be able to save it")
            return()
        }
        popViewController(animated: true)
        buttonContinueHandler?(location!)
    }

    @IBAction func buttonSaveAsNew(_ sender: Any) {
        if modelUserAddressesResponseData == nil {
            if textFieldSearch.text == "" {
                showToast(message: "Search address then you will be able to save it")
                return()
            }
            self.navigateToAddAddressViewController()
        }
        else {
            navigateToAddAddressViewControllerFromEditButton()
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
        vc.newAddressAddedHandler = {
            self.getUserAddress()
        }
        vc.location = location
        vc.newAddress = textFieldSearch.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddressesListViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddressesListViewController") as! AddressesListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddAddressViewControllerFromEditButton() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.addressEditHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.popViewController(animated: false)
                self.buttonContinueHandler(CLLocationCoordinate2D())
            }
        }
        vc.isEditAddress = true
        vc.modelUserAddressesResponseData = modelUserAddressesResponseData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setZoom(latitude: Double? = 47.07903, longitude: Double? = -122.961283) {
        let lat = latitude!
        let long = longitude!
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
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
        labelAddressTitle.text = addressTitle
        labelAddress.text = formattedAddress
        
        modelUserAddressesResponseData?.name = addressTitle
        modelUserAddressesResponseData?.address = formattedAddress
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
        APIs.postAPI(apiName: .getuseraddress, methodType: .get, viewController: self) { responseData, success, errorMsg in
            let model: AddressesListViewController.ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
}

extension EditAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            print("dragged")
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if modelUserAddressesResponseData != nil {
            labelButtonSaveAsNew.textColor = .black
            buttonSaveAsNew.isUserInteractionEnabled = true
            labelButtonSaveAsNew.text = "Update"
        }
        
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.location = center
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
        if modelUserAddressesResponseData != nil {
            labelButtonSaveAsNew.textColor = .black
            buttonSaveAsNew.isUserInteractionEnabled = true
            labelButtonSaveAsNew.text = "Update"
        }
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")

//        textFieldSearch.text = place.name
        DispatchQueue.main.async {
            self.location = place.coordinate
            self.setAddress(addressTitle: "\(place.name ?? "")" , formattedAddress: place.formattedAddress)
            self.setZoom(latitude: self.location?.latitude, longitude: self.location?.longitude)
        }
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
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.location = location.coordinate
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in

            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }

            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            print(reversedGeoLocation.formattedAddress)
            
            self.setAddress(addressTitle: "\(reversedGeoLocation.name) \(reversedGeoLocation.city)" , formattedAddress: reversedGeoLocation.formattedAddress)
            self.setZoom(latitude: self.location?.latitude, longitude: self.location?.longitude)
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

    var formattedAddress: String {
        return """
        \(name), \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode) \(country)
        """
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
