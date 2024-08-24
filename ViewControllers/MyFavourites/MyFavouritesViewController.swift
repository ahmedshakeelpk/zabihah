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
    @IBOutlet weak var viewButtonTabBackGround: UIView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var imageViewMosque: UIImageView!
    @IBOutlet weak var stackViewButtonTabBackGround: UIStackView!
    
    @IBOutlet weak var buttonPrayerPlaces: UIButton!
    @IBOutlet weak var buttonRestaurant: UIButton!
    @IBOutlet weak var imageViewNoRecordFound: UIImageView!
    @IBOutlet weak var labelNoRecordFound: UILabel!

    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var viewNoDataFoundBackGround: UIView!
    var favouritePageNumber = 1

    var selectedIndex: Int? = 0 {
        didSet {

        }
    }
    var modelGetFavouriteByUserResponse: ModelGetFavouriteByUserResponse? {
        didSet {
            if modelGetFavouriteByUserResponse?.halalRestuarantResponseData?.count ?? 0 > 0 {
            }
            tableViewReload()
        }
    }
    
    func tableViewReload() {
        tableView.reloadData()
        viewNoDataFoundBackGround.isHidden = false
        tableView.isHidden = true
        if buttonRestaurant.tag == 1 {
            if modelGetFavouriteByUserResponse?.halalRestuarantResponseData?.count ?? 0 > 0 {
                tableView.isHidden = false
                viewNoDataFoundBackGround.isHidden = true
            }
        }
        else {
            if modelGetFavouriteByUserResponse?.prayerSpacesResponseData?.count ?? 0 > 0 {
                tableView.isHidden = false
                viewNoDataFoundBackGround.isHidden = true
            }
        }
    }
    
    var modelPostFavouriteDeleteResponse: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? {
        didSet {
            print(modelPostFavouriteDeleteResponse as Any)
            if modelPostFavouriteDeleteResponse?.success ?? false {
                self.getFavouriteByUser()
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
//        stackViewButtonTabBackGround.setShadow(radius: 6)
        stackViewButtonTabBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 6)
        viewButtonTabBackGround.backgroundColor = .clear
        viewButtonTabBackGround.setShadow(radius: 0)
        
        imageViewNoRecordFound.isHidden = false
        viewBottomLinePrayerPlaces.isHidden = true
        buttonRestaurant.tag = 1
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        
        imageViewRestaurant.image = imageViewRestaurant.image?.withRenderingMode(.alwaysTemplate)
        imageViewMosque.image = imageViewMosque.image?.withRenderingMode(.alwaysTemplate)
        imageViewRestaurant.tintColor = .colorApp
        imageViewMosque.tintColor = .clrUnselectedImage
        buttonRestaurant.tag = 1
        getFavouriteByUser()
    }

    @IBOutlet weak var viewBottomLineRestaurants: UIView!
    @IBOutlet weak var viewBottomLinePrayerPlaces: UIView!
    @IBAction func buttonRestaurant(_ sender: Any) {
        viewBottomLinePrayerPlaces.isHidden = true
        viewBottomLineRestaurants.isHidden = false
        buttonRestaurant.tag = 1
        imageViewRestaurant.tintColor = .colorApp
        imageViewMosque.tintColor = .clrUnselectedImage
//        tableViewReload()
        getFavouriteByUser()
    }
    
    @IBAction func buttonPrayerPlaces(_ sender: Any) {
        viewBottomLinePrayerPlaces.isHidden = false
        viewBottomLineRestaurants.isHidden = true
        buttonRestaurant.tag = 0
        imageViewRestaurant.tintColor = .clrUnselectedImage
        imageViewMosque.tintColor = .colorApp
//        tableViewReload()
        getFavouriteByUser()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
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
            "type": buttonRestaurant.tag == 1 ? "rest" : "prayer"
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
        actionSheetLogout(index: index)
    }
    
    //Mark:- Choose Action Sheet
    func actionSheetLogout(index: Int) {
        var myActionSheet = UIAlertController(title: "Delete Favourite!", message: "Are you sure you want to delete favourite item?", preferredStyle: UIAlertController.Style.actionSheet)
        myActionSheet.view.tintColor = UIColor.black
        let galleryAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.deleteUserAddress(index: index)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if IPAD {
            //In iPad Change Rect to position Popover
            myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        }
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cancelAction)
        self.present(myActionSheet, animated: true, completion: nil)
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
        
        let recordModel: HomeViewController.ModelRestuarantResponseData!
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
//        if buttonRestaurant.tag == 0 {
//            let recordModel = modelGetFavouriteByUserResponse?.halalRestuarantResponseData?[indexPath.row]
//        }
//        else {
//            let recordModel = modelGetFavouriteByUserResponse?.prayerSpacesResponseData?[indexPath.row]
//        }
        
        
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
        navigateToDeliveryDetailsViewController(indexPath: indexPath)
    }
    func navigateToDeliveryDetailsViewController(indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
//        vc.delegate = self
        
        vc.selectedMenuCell = 0
        vc.userLocation = kUserCurrentLocation
        if buttonRestaurant.tag == 1 {
            vc.modelRestuarantResponseData = modelGetFavouriteByUserResponse?.halalRestuarantResponseData?[indexPath.row]
        }
        else {
            vc.modelRestuarantResponseData = modelGetFavouriteByUserResponse?.prayerSpacesResponseData?[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
