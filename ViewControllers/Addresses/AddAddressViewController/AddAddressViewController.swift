//
//  AddAddressViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonEditAddress: UIButton!
    @IBOutlet weak var viewAddressSubBackGround: UIView!
    @IBOutlet weak var viewAddressBackGround: UIView!
    @IBOutlet weak var stackViewSearchBackGround: UIStackView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewButtonBackBackGround: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtonBackBackGround.radius(radius: 8)
        viewAddressSubBackGround.radius(radius: 8)
        stackViewSearchBackGround.radius(radius: 8)
        setLocation()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
        
    }
    @IBAction func buttonSearch(_ sender: Any) {
        autocompleteClicked()
    }
    @IBAction func buttonEditAddress(_ sender: Any) {
        editUserAddress()
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
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
    
    var modelEditUserAddressResponse: ModelEditUserAddressResponse? {
        didSet {
            if modelEditUserAddressResponse?.status == 500 {
                
            }
            else {

            }
        }
    }
    
    func editUserAddress() {
        let parameters: Parameters = [
            "id": "string",
            "title": "string",
            "address": "string",
            "name": "string",
            "latitude": 0,
            "longitude": 0,
            "deliveryInstructions": "string",
            "locationInstruction": "string",
            "isDefault": true
        ]
        APIs.postAPI(apiName: .edituseraddress, parameters: parameters, methodType: .delete, viewController: self) { responseData, success, errorMsg in
            let model: ModelEditUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelEditUserAddressResponse = model
        }
    }
}

extension AddAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
    }
}

extension AddAddressViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")

        textFieldSearch.text = place.name
        DispatchQueue.main.async {
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
extension AddAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
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
