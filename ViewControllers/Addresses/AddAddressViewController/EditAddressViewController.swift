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
    
    @IBOutlet weak var viewAddressMainBackGround: UIView!
    @IBOutlet weak var viewButtonsBackGround: UIView!
    
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
        
    var buttonContinueHandler: ((CLLocationCoordinate2D) -> ())!
    var location: CLLocationCoordinate2D? {
        didSet {
            
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
                }
                labelAddressTitle.text = modelGetUserAddressResponse?.userAddressesResponseData?[defaultAddressIndex!].title
                labelAddress.text = modelGetUserAddressResponse?.userAddressesResponseData?[defaultAddressIndex!].address
            }
            else {
                viewAddressMainBackGround.isHidden = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtonBackBackGround.radius(radius: 8)
        viewAddressSubBackGround.radius(radius: 8)
        stackViewSearchBackGround.radius(radius: 8)
        stackViewAddressBackGround.radius(radius: 8)
        viewButtonSaveAsNewBackGround.radius(color: .clrLightGray, borderWidth: 1)

        setLocation()
        getUserAddress()
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
        if textFieldSearch.text == "" {
            showToast(message: "Search address then you will be able to save it")
            return()
        }
        self.navigateToAddAddressViewController()
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
    
    func navigateToAddAddressViewControllerFromEditButton() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.newAddressAddedHandler = {
            self.getUserAddress()
        }
        vc.isEditAddress = true
        vc.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[defaultAddressIndex!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setLocation(latitude: Double? = 47.07903, longitude: Double? = -122.961283) {
        let lat = latitude!
        let long = longitude!
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.map = self.mapView
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
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
    }
}

extension EditAddressViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")

        textFieldSearch.text = place.name
        DispatchQueue.main.async {
            self.location = place.coordinate
            self.setLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
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
