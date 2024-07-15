//
//  AddressesListViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit
import Alamofire

class AddressesListViewController: UIViewController {

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
                
                tableView.reloadData()
            }
        }
    }
    
    var modelDeleteUserAddressResponse: ModelDeleteUserAddressResponse? {
        didSet {
            if modelDeleteUserAddressResponse?.success ?? false {
                getUserAddress()
                showAlertCustomPopup(title: "Success", message: modelDeleteUserAddressResponse?.message ?? "", iconName: .iconSuccess) { _ in
                    
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelDeleteUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    var arrayTitle = ["Mango", "Ferrerri", "Toyota", "Honda", "Cycle", "iPhone", "Android", "Serina"]
    var arrayAddress = ["A quick brown", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressesCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)
        getUserAddress()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonAddNewAddress(_ sender: Any) {
        navigateToAddAddressViewController()
    }
    
    func navigateToEditAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
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
        let parameters: Parameters = [
            "id": modelGetUserAddressResponse?.userAddressesResponseData?[index].id ?? ""
        ]
        APIs.postAPI(apiName: .deleteuseraddress, parameters: parameters, methodType: .delete, viewController: self) { responseData, success, errorMsg in
            let model: ModelDeleteUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelDeleteUserAddressResponse = model
        }
    }
    
    func buttonEditAddress(index: Int) {
        navigateToAddAddressViewControllerFromEditButton(index: index)
    }
    func navigateToAddAddressViewControllerFromEditButton(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.addressEditHandler = {
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        selectedAddressIndex = indexPath.row
    }
}
