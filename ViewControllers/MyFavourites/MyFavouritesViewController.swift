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

    @IBOutlet weak var buttonPrayerPlaces: UIButton!
    @IBOutlet weak var buttonRestaurant: UIButton!
    @IBOutlet weak var imageViewNoAddressFound: UIImageView!
    @IBOutlet weak var buttonAddNewAddress: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var viewNoDataFoundBackGround: UIView!
    var favouritePageNumber = 1

    var selectedIndex: Int? = 0 {
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
                tableView.isHidden = true
            }
            else {
                viewNoDataFoundBackGround.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    var modelPostFavouriteDeleteResponse: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? {
        didSet {
            print(modelPostFavouriteDeleteResponse as Any)
            if modelPostFavouriteDeleteResponse?.success ?? false {
                tableView.reloadData()
            }
            else {
                self.showAlertCustomPopup(title: "Error!", message: modelPostFavouriteDeleteResponse?.message ?? "", iconName: .iconError)
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
        viewBottomLinePrayerPlaces.isHidden = true
        buttonRestaurant.tag = 1
    }

    @IBOutlet weak var viewBottomLineRestaurants: UIView!
    @IBOutlet weak var viewBottomLinePrayerPlaces: UIView!
    @IBAction func buttonRestaurant(_ sender: Any) {
        viewBottomLinePrayerPlaces.isHidden = true
        viewBottomLineRestaurants.isHidden = false
        buttonRestaurant.tag = 1
        tableView.reloadData()
    }
    
    @IBAction func buttonPrayerPlaces(_ sender: Any) {
        viewBottomLinePrayerPlaces.isHidden = false
        viewBottomLineRestaurants.isHidden = true
        buttonRestaurant.tag = 0
        tableView.reloadData()
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
        var deleteID = ""
        var type = ""
        if buttonRestaurant.tag == 1 {
            deleteID = modelGetFavouriteByUserResponse?.halalRestuarantResponseData?[index].id ?? "0"
            type = "rest"
        }
        else {
            deleteID = modelGetFavouriteByUserResponse?.prayerSpacesResponseData?[index].id ?? "0"
            type = "prayer"
        }
        
        let parameters = [
            "Id": deleteID,
            "isMark": false,
            "type" : type
        ] as [String : Any]
       
        APIs.postAPI(apiName: .postfavouriterestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelPostFavouriteDeleteResponse = model
        }
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
        showAlertCustomPopup(title: "Delete Favourite!", message: "Are you sure you want to delte favourite item?", iconName: .iconError, buttonNames: [
            [
                "buttonName": "Delete",
                "buttonBackGroundColor": UIColor.white,
                "buttonTextColor": UIColor.colorRed] as [String : Any],
            [
                "buttonName": "Cancel",
                "buttonBackGroundColor": UIColor.colorRed,
                "buttonTextColor": UIColor.white]
        ] as? [[String: AnyObject]]) {buttonName in
            if buttonName == "Cancel" {
                
            }
            else if buttonName == "Delete" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.deleteUserAddress(index: index)
                }
            }
        }
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
        if buttonRestaurant.tag == 1 {
            return modelGetFavouriteByUserResponse?.halalRestuarantResponseData?.count ?? 0
        }
        else {
            return modelGetFavouriteByUserResponse?.prayerSpacesResponseData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavouriteCell") as! MyFavouriteCell
        
        let recordModel: ModelGetFavouriteByUserResponseData!
        if buttonRestaurant.tag == 1 {
            recordModel = modelGetFavouriteByUserResponse?.halalRestuarantResponseData?[indexPath.row]
        }
        else {
            recordModel = modelGetFavouriteByUserResponse?.prayerSpacesResponseData?[indexPath.row]
        }
        
        cell.halalRestuarantResponseData = recordModel
        cell.index = indexPath.row
        cell.selectedAddressIndex = selectedIndex
        cell.buttonDeleteHandler = buttonDeleteAddress
        cell.buttonCheckHandler = buttonCheckHandler
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        if buttonRestaurant.tag == 0 {
            let recordModel = modelGetFavouriteByUserResponse?.halalRestuarantResponseData?[indexPath.row]
        }
        else {
            let recordModel = modelGetFavouriteByUserResponse?.prayerSpacesResponseData?[indexPath.row]
        }
        
        
        selectedIndex = indexPath.row
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeViewController.self) {
//                if let targetViewController = controller as? HomeViewController {
//                    targetViewController.getuser()
////                    if let model = modelGetUserAddressResponse?.userAddressesResponseData?[indexPath.row] {
//////                        targetViewController.selectedAddress(modelUserAddressesResponseData: model)
////                    }
//                    self.navigationController!.popToViewController(controller, animated: true)
//                }
//                break
//            }
//        }
    }
}
