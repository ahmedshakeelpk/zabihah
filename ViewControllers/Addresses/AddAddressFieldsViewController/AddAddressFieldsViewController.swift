//
//  AddAddressFieldsViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire


class AddAddressFieldsViewController: UIViewController {
   
    @IBOutlet weak var switchDefaultAddress: UISwitch!{
        didSet{
            switchDefaultAddress.onTintColor = .clrApp
        }
    }
    
    @IBOutlet weak var buttonSearchAddress: UIButton!
    @IBOutlet weak var viewAddNewAddressBackGround: UIView!
    @IBOutlet weak var textFieldLocationInstructionOptional: UITextField!
    @IBOutlet weak var labelDeliveryInstructionCount: UILabel!
    @IBOutlet weak var textFieldDeliveryInstruction: UITextField!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSwitchDefaultAddressBackGround: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewButtonBackBackGround: UIView!
    @IBOutlet weak var buttonSave: UIButton!
    
    let arrayNames = ["Home", "Office", "Person", "Other"]
    let arrayNamesIcon = ["houseWhiteMisc", "briefcaseBlackMisc", "userBlackMisc", "addCircleBlackMisc"]

    var latitude: Double!
    var longitude: Double!
    var locationId: String!
    var selectedCell: Int!
    
    var modelGetUserAddressResponse: ModelGetUserAddressResponse? {
        didSet {
            if modelGetUserAddressResponse?.status == 500 {
                
            }
            else {

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtonBackBackGround.radius(radius: 8)
        viewSwitchDefaultAddressBackGround.radius(radius: 8)
        viewAddNewAddressBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        AddAddressFieldsCell.register(collectionView: collectionView)
        self.setLocation()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonSave(_ sender: Any) {
        if textFieldAddress.text == "" {
            self.showToast(message: "Please enter address!")
        }
        else {
            addUserAddress()
        }
    }
    
    @IBAction func buttonSearchAddress(_ sender: Any) {
        autocompleteClicked()
    }
    
    @IBAction func switchDefaultAddress(_ sender: Any) {
        
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
    
    func addUserAddress() {
        let parameters: Parameters = [
            "id": locationId ?? "",
            "title": arrayNames[selectedCell],
            "address": textFieldAddress.text!,
            "name": arrayNames[selectedCell],
            "latitude": latitude ?? 0,
            "longitude": longitude ?? 0,
            "deliveryInstructions": textFieldDeliveryInstruction.text!,
            "locationInstruction": textFieldLocationInstructionOptional.text!,
            "isDefault": switchDefaultAddress.isOn
        ]
        APIs.postAPI(apiName: .adduseraddress, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
}


extension AddAddressFieldsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
        let width = collectionView.frame.width / 3 - 8
        return CGSize(width: 60, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressFieldsCell", for: indexPath) as! AddAddressFieldsCell
        cell.labelName.text = arrayNames[indexPath.item]
        cell.imageViewTitle.image = UIImage(named: arrayNamesIcon[indexPath.item])
        if selectedCell != nil {
            if indexPath.item == selectedCell {
                cell.viewImageViewTitleBackGround.backgroundColor = .clrApp
            }
            else {
                cell.viewImageViewTitleBackGround.backgroundColor = .clrUnselected
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}

extension AddAddressFieldsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
    }
}

extension AddAddressFieldsViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")
        textFieldAddress.text = place.name
        locationId = place.placeID ?? ""
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
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
extension AddAddressFieldsViewController: GMSAutocompleteResultsViewControllerDelegate {
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
