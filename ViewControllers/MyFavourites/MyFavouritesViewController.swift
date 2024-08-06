//
//  MyFavouritesViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/08/2024.
//

import UIKit
import Alamofire
import GooglePlaces

class MyFavouritesViewController: UIViewController {

    @IBOutlet weak var imageViewNoAddressFound: UIImageView!
    @IBOutlet weak var buttonAddNewAddress: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var viewNoDataFoundBackGround: UIView!
    var favouritePageNumber = 1

    var selectedAddressIndex: Int? = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    var modelGetFavouriteByUserResponse: ModelGetFavouriteByUserResponse? {
        didSet {
            if modelGetFavouriteByUserResponse?.halalRestuarantResponseData?.count ?? 0 > 0 {
                tableView.reloadData()
            }
            
            if tableView.visibleCells.count == 0 {
                viewNoDataFoundBackGround.isHidden = false
            }
            else {
                viewNoDataFoundBackGround.isHidden = true
            }
        }
    }
    
    var modelDeleteUserAddressResponse: ModelDeleteUserAddressResponse? {
        didSet {
            if modelDeleteUserAddressResponse?.success ?? false {
                getFavouriteByUser()
                showAlertCustomPopup(title: "Success", message: modelDeleteUserAddressResponse?.message ?? "", iconName: .iconSuccess) { _ in
                    self.tableView.reloadData()
                    self.getFavouriteByUser()
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelDeleteUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoDataFoundBackGround.isHidden = true
        MyFavouriteCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)
        getFavouriteByUser()
        imageViewNoAddressFound.isHidden = false
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonAddNewAddress(_ sender: Any) {
        navigateToAddAddressViewController()
    }
    
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.newAddressAddedHandler = {
            self.getFavouriteByUser()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFavouriteByUser() {
        let parameters: Parameters = [
            "page": favouritePageNumber,
            "type": "rest"
        ]
        APIs.postAPI(apiName: .getfavouritebyuser, parameters: parameters, methodType: .post, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetFavouriteByUserResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetFavouriteByUserResponse = model
        }
    }
    
    func deleteUserAddress(index: Int) {
//        let parameters: Parameters = [
//            "id": modelGetUserAddressResponse?.userAddressesResponseData?[index].id ?? ""
//        ]
//        let id = modelGetUserAddressResponse?.userAddressesResponseData?[index].id ?? ""
//        
//        let url = "\(APIsName.name.deleteuseraddress.rawValue)/\(id)"
//        APIs.deleteAPI(apiName: url, parameters: nil, methodType: .delete, viewController: self) { responseData, success, errorMsg in
//            let model: ModelDeleteUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelDeleteUserAddressResponse = model
//        }
    }
    
    func navigateToAddAddressViewControllerFromEditButton(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.addressEditHandler = { location in
            self.getFavouriteByUser()
        }
        vc.isEditAddress = true
//        vc.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[index]
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

    }
    var modelEditUserAddressResponse: AddAddressViewController.ModelEditUserAddressResponse? {
        didSet {
            if modelEditUserAddressResponse?.success ?? false {
                getFavouriteByUser()
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelEditUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
}

extension MyFavouritesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetFavouriteByUserResponse?.halalRestuarantResponseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavouriteCell") as! MyFavouriteCell
        cell.halalRestuarantResponseData = modelGetFavouriteByUserResponse?.halalRestuarantResponseData?[indexPath.row]
        cell.index = indexPath.row
        cell.selectedAddressIndex = selectedAddressIndex
        cell.buttonDeleteHandler = buttonDeleteAddress
        cell.buttonCheckHandler = buttonCheckHandler
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        selectedAddressIndex = indexPath.row
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                if let targetViewController = controller as? HomeViewController {
                    targetViewController.getuser()
//                    if let model = modelGetUserAddressResponse?.userAddressesResponseData?[indexPath.row] {
////                        targetViewController.selectedAddress(modelUserAddressesResponseData: model)
//                    }
                    self.navigationController!.popToViewController(controller, animated: true)
                }
                break
            }
        }
    }
}
