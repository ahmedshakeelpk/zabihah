//
//  AddressesListViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit
import Alamofire
import GooglePlaces

class AddressesListViewController: UIViewController {

    @IBOutlet weak var imageViewNoAddressFound: UIImageView!
    @IBOutlet weak var buttonAddNewAddress: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    var selectedAddressIndex: Int? = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    var modelGetUserAddressResponse: ModelGetUserAddressResponse? {
        didSet {
            if modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0 > 0 {
                if let defaultAddressIndex = modelGetUserAddressResponse?.userAddressesResponseData?.firstIndex(where: { model in
                    model.isDefault ?? false
                }) {
                    selectedAddressIndex = defaultAddressIndex
                }
                else {
                    print("No default address found.")
                }
                imageViewNoAddressFound.isHidden = true
            }
            else {
                imageViewNoAddressFound.isHidden = false
            }
            
//            if tableView.visibleCells.count == 0 {
//                imageViewNoAddressFound.isHidden = false
//            }
//            else {
//                imageViewNoAddressFound.isHidden = true
//            }
            tableView.reloadData()
        }
    }
    
    var modelDeleteUserAddressResponse: ModelDeleteUserAddressResponse? {
        didSet {
            if modelDeleteUserAddressResponse?.success ?? false {
                getUserAddress()
//                showAlertCustomPopup(title: "Success", message: modelDeleteUserAddressResponse?.message ?? "", iconName: .iconSuccess) { _ in
//                    self.tableView.reloadData()
//                    self.getUserAddress()
//                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelDeleteUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressesCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)
        getUserAddress()
        imageViewNoAddressFound.isHidden = false
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonAddNewAddress(_ sender: Any) {
//        navigateToAddAddressViewController()
        navigateToEditAddressViewController()
    }
    
    func navigateToEditAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        vc.isFromAddressList = true
        vc.isFromAddressListAddNewButton = true
        vc.buttonContinueHandler = { (_, _) in
            self.getUserAddress()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.newAddressAddedHandler = {
            self.getUserAddress()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUserAddress() {
        APIs.postAPI(apiName: .getuseraddress, methodType: .get, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
    
    func deleteUserAddress(index: Int) {
        let id = modelGetUserAddressResponse?.userAddressesResponseData?[index].id ?? ""
        
        let url = "\(APIsName.name.deleteuseraddress.rawValue)/\(id)"
        APIs.deleteAPI(apiName: url, parameters: nil, methodType: .delete, viewController: self) { responseData, success, errorMsg in
            let model: ModelDeleteUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelDeleteUserAddressResponse = model
        }
    }
    
    func buttonEditAddress(index: Int) {
        navigateToEditAddressesViewController(index: index)
    }
    func navigateToEditAddressesViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        vc.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[index]
       
        vc.buttonContinueHandler = { (address, location) in
            print("button continue pressed \(String(describing: location))")
            self.getUserAddress()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddAddressViewControllerFromEditButton(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.addressEditHandler = { location in
            self.getUserAddress()
        }
        vc.isEditAddress = true
        vc.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func buttonDeleteAddress(index: Int) {
        let refreshAlert = UIAlertController(title: "User Address", message: "Are you sure you want to delete Address?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.deleteUserAddress(index: index)
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    func buttonCheckHandler(index: Int) {
        editUserAddress(index: index)
    }
    var modelEditUserAddressResponse: AddAddressViewController.ModelEditUserAddressResponse? {
        didSet {
            if modelEditUserAddressResponse?.success ?? false {
                getUserAddress()
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelEditUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    func editUserAddress(index: Int) {
        let parameters: Parameters = [
            "id": modelGetUserAddressResponse?.userAddressesResponseData?[index].id ?? "",
            "isDefault": true
        ]
        APIs.postAPI(apiName: .edituseraddress, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg in
            let model: AddAddressViewController.ModelEditUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelEditUserAddressResponse = model
        }
    }
}

extension AddressesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell") as! AddressesCell
        cell.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[indexPath.row]
        cell.index = indexPath.row
        cell.selectedAddressIndex = selectedAddressIndex
        cell.buttonEditHandler = buttonEditAddress
        cell.buttonDeleteHandler = buttonDeleteAddress
        cell.buttonCheckHandler = buttonCheckHandler
        
        if modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0 == 1 {
            cell.viewButtonDeleteBackGround.isHidden = true
        }
        else {
            cell.viewButtonDeleteBackGround.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        selectedAddressIndex = indexPath.row
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                if let targetViewController = controller as? HomeViewController {
                    targetViewController.getuser()
                    if let model = modelGetUserAddressResponse?.userAddressesResponseData?[indexPath.row] {
                        targetViewController.selectedAddress(modelUserAddressesResponseData: model)
                    }
                    self.navigationController!.popToViewController(controller, animated: true)
                }
                break
            }
        }
    }
}
