//
//  AddAddressViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire


class AddAddressViewController: UIViewController {
   
    @IBOutlet weak var switchDefaultAddress: UISwitch!{
        didSet{
            switchDefaultAddress.onTintColor = .colorApp
        }
    }
    @IBOutlet weak var labelMainTitle: UILabel!
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
    @IBOutlet weak var viewBackGroundButtonSave: ViewButtonSetting!
    
    let arrayNames = ["Home", "Office", "Person", "Other"]
    let arrayNamesIconMehroon = ["houseMehroon", "briefcaseMehroon", "userMehroon", "addCircleMehroon"]
    let arrayNamesIconWhite = ["houseWhite", "briefcaseWhite", "userWhite", "addCircleWhite"]

    var isEditAddress = false
    var newAddress = String()
    var location: CLLocationCoordinate2D? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.textFieldAddress.text = self.newAddress
                self.setLocation(latitude: self.location?.latitude, longitude: self.location?.longitude)
                self.fieldVilidation()
            }
        }
    }
    
    var modelEditUserAddressResponse: ModelEditUserAddressResponse? {
        didSet {
            if modelEditUserAddressResponse?.success ?? false {
                self.popViewController(animated: true)
                self.addressEditHandler?(self.location!)
//                showAlertCustomPopup(title: "Success", message: modelEditUserAddressResponse?.message ?? "", iconName: .iconSuccess) { _ in
//                    self.popViewController(animated: true)
//                    self.addressEditHandler?(self.location!)
//                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelAddUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    var modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData? {
        didSet {
            if modelUserAddressesResponseData == nil {
                return()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                self.labelMainTitle.text = "Edit Address"
                self.newAddress = self.modelUserAddressesResponseData?.address ?? ""
                self.location = CLLocationCoordinate2D(latitude: (modelUserAddressesResponseData?.latitude)!, longitude: (modelUserAddressesResponseData?.longitude)!)
                self.setLocation(latitude: modelUserAddressesResponseData?.latitude, longitude: self.modelUserAddressesResponseData?.longitude)
                self.textFieldDeliveryInstruction.text = modelUserAddressesResponseData?.deliveryInstructions
                self.textFieldLocationInstructionOptional.text = modelUserAddressesResponseData?.locationInstruction
                self.switchDefaultAddress.isOn = modelUserAddressesResponseData?.isDefault ?? false
                if let indexOf = arrayNames.firstIndex(where: { name in
                    name == modelUserAddressesResponseData?.title
                }) {
                    selectedCell = indexOf
                    collectionView.reloadData()
                }
                self.textFieldDeliveryInstructionEditingChanged()
            }
        }
    }
    
    var locationId: String!
    var selectedCell: Int! = 0
    var newAddressAddedHandler: (() -> ())!
    var addressEditHandler: ((CLLocationCoordinate2D) -> ())!

    var modelAddUserAddressResponse: ModelAddUserAddressResponse? {
        didSet {
            if modelAddUserAddressResponse?.success ?? false {
                self.popViewController(animated: true)
                self.newAddressAddedHandler?()
//                showAlertCustomPopup(title: "Success", message: modelAddUserAddressResponse?.message ?? "", iconName: .iconSuccess) { _ in
//                    self.popViewController(animated: true)
//                    self.newAddressAddedHandler?()
//                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelAddUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfiguration()
    }
    @objc func textFieldDeliveryInstructionEditingChanged() {
        if let count = textFieldDeliveryInstruction.text?.count {
            if count > 300 {
                textFieldDeliveryInstruction.text?.removeLast()
                return()
            }
        }
        labelDeliveryInstructionCount.text = "\(textFieldDeliveryInstruction.text?.count ?? 0)/300"
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonSave(_ sender: Any) {
        if textFieldAddress.text == "" {
            self.showToast(message: "Please enter address!")
        }
        else {
            if isEditAddress {
                self.editUserAddress()
            }
            else {
                self.addUserAddress()
            }
        }
    }
    
    @IBAction func buttonSearchAddress(_ sender: Any) {
        autocompleteClicked()
    }
    
    @IBAction func switchDefaultAddress(_ sender: Any) {
        
    }
    
    
    func setConfiguration() {
        textFieldAddress.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        
        viewButtonBackBackGround.radius(radius: 8)
        viewSwitchDefaultAddressBackGround.radius(radius: 8)
        viewAddNewAddressBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        AddAddressFieldsCell.register(collectionView: collectionView)
        self.setLocation()
        textFieldDeliveryInstruction.addTarget(self, action: #selector(textFieldDeliveryInstructionEditingChanged), for: .editingChanged)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 20)

        fieldVilidation()
    }
    @objc func fieldVilidation() {
        var isValid = true
        if textFieldAddress.text == "" {
            isValid = false
        }
        buttonSave.isEnabled = isValid
        viewBackGroundButtonSave.backgroundColor = isValid ? .clrLightBlue : .clrDisableButton
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
//            "id": locationId ?? "",
            "title": arrayNames[selectedCell],
            "address": textFieldAddress.text!,
            "name": arrayNames[selectedCell],
            "latitude": location?.latitude ?? 0,
            "longitude": location?.longitude ?? 0,
            "deliveryInstructions": textFieldDeliveryInstruction.text!,
            "locationInstruction": textFieldLocationInstructionOptional.text!,
            "isDefault": switchDefaultAddress.isOn
        ]
        APIs.postAPI(apiName: .adduseraddress, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelAddUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelAddUserAddressResponse = model
        }
    }
    
    func editUserAddress() {
        let parameters: Parameters = [
            "id": modelUserAddressesResponseData?.id ?? "",
            "title": arrayNames[selectedCell],
            "address": textFieldAddress.text!,
            "name": arrayNames[selectedCell],
            "latitude": location?.latitude ?? 0,
            "longitude": location?.longitude ?? 0,
            "deliveryInstructions": textFieldDeliveryInstruction.text!,
            "locationInstruction": textFieldLocationInstructionOptional.text!,
            "isDefault": switchDefaultAddress.isOn
        ]
        APIs.postAPI(apiName: .edituseraddress, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg in
            let model: ModelEditUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelEditUserAddressResponse = model
        }
    }
    
    
    
    
}


extension AddAddressViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
//        let width = collectionView.frame.width / 3 - 8
        return CGSize(width: 60, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressFieldsCell", for: indexPath) as! AddAddressFieldsCell
        cell.labelName.text = arrayNames[indexPath.item]        
        if selectedCell != nil {
            if indexPath.item == selectedCell {
                cell.viewImageViewTitleBackGround.backgroundColor = .colorApp
                cell.imageViewTitle.image = UIImage(named: "\(arrayNamesIconWhite[indexPath.item])")
            }
            else {
                cell.viewImageViewTitleBackGround.backgroundColor = .clrUnselected
                cell.imageViewTitle.image = UIImage(named: "\(arrayNamesIconMehroon[indexPath.item])")
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

extension AddAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
    }
}

extension AddAddressViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
//        print("Place coordinate: \(place.coordinate)")
//        print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")
        self.newAddress = place.name ?? ""
        locationId = place.placeID ?? ""
        location = place.coordinate
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
}

// Handle the user's selection.
extension AddAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        //    searchController?.isActive = false
        // Do something with the selected place.
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
}
