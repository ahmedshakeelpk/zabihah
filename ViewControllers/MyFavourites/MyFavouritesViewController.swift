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
    var modelGetFavouriteResponse: ModelGetFavouriteResponse? {
        didSet {
            DispatchQueue.main.async {
                self.tableViewReload()
            }
        }
    }
    
    func tableViewReload() {
        viewNoDataFoundBackGround.isHidden = false
        tableView.isHidden = true
        if buttonRestaurant.tag == 1 {
            if modelGetFavouriteResponse?.items?.count ?? 0 > 0 {
                tableView.isHidden = false
                viewNoDataFoundBackGround.isHidden = true
            }
        }
        else {
            if modelGetFavouriteResponse?.items?.count ?? 0 > 0 {
                tableView.isHidden = false
                viewNoDataFoundBackGround.isHidden = true
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    var modelPostFavouriteDeleteResponse: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? {
        didSet {
            print(modelPostFavouriteDeleteResponse as Any)
            if modelPostFavouriteDeleteResponse?.success ?? false {
                self.getFavourite()
            }
            else {
                self.showAlertCustomPopup(title: "Error!", message: modelPostFavouriteDeleteResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        stackViewButtonTabBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 6)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoDataFoundBackGround.isHidden = true
        MyFavouriteCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)
//        stackViewButtonTabBackGround.setShadow(radius: 6)
        viewButtonTabBackGround.backgroundColor = .clear
        viewButtonTabBackGround.setShadow(radius: 6)
        
        viewNoDataFoundBackGround.isHidden = false
        viewBottomLinePrayerPlaces.isHidden = true
        buttonRestaurant.tag = 1
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        
        imageViewRestaurant.image = imageViewRestaurant.image?.withRenderingMode(.alwaysTemplate)
        imageViewMosque.image = imageViewMosque.image?.withRenderingMode(.alwaysTemplate)
        imageViewRestaurant.tintColor = .colorApp
        imageViewMosque.tintColor = .clrUnselectedImage
        buttonRestaurant.tag = 1
        getFavourite()
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
        getFavourite()
    }
    
    @IBAction func buttonPrayerPlaces(_ sender: Any) {
        viewBottomLinePrayerPlaces.isHidden = false
        viewBottomLineRestaurants.isHidden = true
        buttonRestaurant.tag = 0
        imageViewRestaurant.tintColor = .clrUnselectedImage
        imageViewMosque.tintColor = .colorApp
//        tableViewReload()
        getFavourite()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.newAddressAddedHandler = {
            self.getFavourite()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getFavourite() {
        let type = buttonRestaurant.tag == 1 ? "Restaurant" : "Mosque"
        let parameters = [
            "page": "\(favouritePageNumber)",
            "pageSize": "20",
            "type": "\(type)"
        ]
        
        APIs.getAPI(apiName: .getFavourite, parameters: parameters, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelGetFavouriteResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelGetFavouriteResponse = model
            }
        }
    }
    
    func deleteFavouritePlaces(index: Int) {
        let parameters = [
            "placeId": modelGetFavouriteResponse?.items?[index]?.place.id ?? "0"
        ]
        APIs.getAPI(apiName: .favouriteDelete, parameters: parameters, isPathParameters: true, methodType: .delete, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostFavouriteRestaurantsResponse = model
            }
        }
    }
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            DispatchQueue.main.async {
                self.getFavourite()
            }
        }
    }
    
    func navigateToAddAddressViewControllerFromEditButton(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.addressEditHandler = { location in
            self.getFavourite()
        }
        vc.isEditAddress = true
//        vc.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func buttonDeleteFavourite(index: Int) {
        navigateToProfileDeleteViewController(index: index)
    }
    
    func navigateToProfileDeleteViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileDeleteViewController") as! ProfileDeleteViewController
        vc.stringTitle = "Delete Favourite!"
        let recordModel: ModelGetFavouriteResponseData!

        if buttonRestaurant.tag == 1 {
            recordModel = modelGetFavouriteResponse?.items?[index]
        }
        else {
            recordModel = modelGetFavouriteResponse?.items?[index]
        }
        
        vc.stringSubTitle = "Are you sure you want to delete \"\(recordModel?.place.name ?? "")\" from favourite places?         "
        vc.stringDescription = ""
        vc.stringButtonDelete = "Yes, Delete"
        vc.stringButtonCancel = "Cancel"
        vc.buttonDeleteHandler = {
            print("delete button press")
            self.deleteFavouritePlaces(index: index)
        }
        self.present(vc, animated: true)
    }
    
    //Mark:- Choose Action Sheet
    func actionSheetFavouriteDelete(index: Int) {
        var myActionSheet = UIAlertController(title: "Delete Favourite?", message: "Are you sure you want to delete favourite item?", preferredStyle: UIAlertController.Style.actionSheet)
        myActionSheet.view.tintColor = UIColor.black
        let galleryAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.deleteFavouritePlaces(index: index)
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
                getFavourite()
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelEditUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
}

extension MyFavouritesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetFavouriteResponse?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavouriteCell") as! MyFavouriteCell
        
        var recordModel: MyFavouritesViewController.ModelGetFavouriteResponseData!
        recordModel = modelGetFavouriteResponse?.items?[indexPath.row]
        
        cell.selectedIndex = buttonRestaurant.tag == 1 ? 0 : 1
        cell.modelGetFavouriteResponseData = recordModel
        cell.index = indexPath.row
        cell.selectedAddressIndex = selectedIndex
        cell.buttonDeleteHandler = buttonDeleteFavourite
        cell.buttonCheckHandler = buttonCheckHandler
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        let recordModel = modelGetFavouriteResponse?.items?[indexPath.row]
        
        selectedIndex = indexPath.row
        navigateToDeliveryDetailsViewController(indexPath: indexPath)
    }
    func navigateToDeliveryDetailsViewController(indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
//        vc.delegate = self
        
        vc.selectedMenuCell = 0
        vc.userLocation = kUserCurrentLocation
        if buttonRestaurant.tag == 1 {
//            vc.modelRestuarantResponseData = modelGetFavouriteResponse?.items?[indexPath.row]
        }
        else {
//            vc.modelRestuarantResponseData = modelGetFavouriteResponse?.items?[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
