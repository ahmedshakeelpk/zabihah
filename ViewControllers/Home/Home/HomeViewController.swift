//
//  HomeViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import Alamofire
import GoogleMaps
import CoreLocation


extension HomeViewController: GMSMapViewDelegate{
    
}
class HomeViewController: UIViewController {
    @IBOutlet weak var imageViewNoRecordFound: UIImageView!
    @IBOutlet weak var labelNoRecordFound: UILabel!
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var buttonFilters: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageViewListViewMapView: UIImageView!
    @IBOutlet weak var buttonMapViewListView: UIButton!
    
    @IBOutlet weak var viewMapViewBackground: UIView!
    @IBOutlet weak var buttonSideMenu: UIButton!
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var stackViewSearchNearLocationBackGround: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackViewSearchNTextFieldNearLocationBackGround: UIStackView!
    @IBOutlet weak var viewSettingBackGround: UIView!
    @IBOutlet weak var stackViewFilterResultBackGround: UIStackView!
    @IBOutlet weak var textFieldFilterResult: UITextField!
    @IBOutlet weak var textFieldSearchLocation: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSearchLocation: UIButton!
    @IBOutlet weak var labelMapViewListView: UILabel!
    
    var locationManager = CLLocationManager()
    var selectedCuisine: String = "" {
        didSet {
//            pageNumberHalalFood = 1
        }
    }
    
    var modelUserConfigurationResponse: ModelUserConfigurationResponse? {
        didSet {
            //Location Services
            locationManager.delegate = self
    //        if CLLocationManager.locationServicesEnabled() {
    //             switch CLLocationManager.authorizationStatus() {
    //                case .notDetermined, .restricted, .denied:
    //                    print("No access")
    //                case .authorizedAlways, .authorizedWhenInUse:
    //                    print("Access")
    //
    //             }
    //        }
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    var filterParametersHome: [String: Any]!
    
    var selectedMenuCell: Int = 0 {
        didSet {
            addCellInList()
            handleMenuTap()
        }
    }
    var pageNumberForApi: Int! = 1 {
        didSet {
            if selectedMenuCell == 0 {
                
            }
            else if selectedMenuCell == 1 {
                if pageNumberForApi == 0 {
                    return
                }
                if pageNumberForApi > 1 {
                    if pageNumberForApi > modelGetHalalRestaurantResponse?.totalPages ?? 0 {
                        return()
                    }
                }
                getHalalRestaurants(pageSize: pageNumberForApi, cuisine: selectedCuisine)
            }
            else if selectedMenuCell == 3 {
                if pageNumberForApi == 0 {
                    return
                }
                if pageNumberForApi > 1 {
                    if pageNumberForApi > modelGetHalalRestaurantResponse?.totalPages ?? 0 {
                        return()
                    }
                }
                getPrayerPlaces(pageSize: pageNumberForApi)
            }
        }
    }
    func itself<T>(_ value: T) -> T {
        return value
    }
    var userLocation: CLLocation! {
        didSet {
            filterParametersHome = nil
            self.selectedMenuCell = itself(selectedMenuCell)
        }
    }

    var dontTriggerModelGetHomeRestaurantsResponseObservers:Bool = false
    var dontTriggerModelGetHalalRestaurantResponseObservers:Bool = false

    var modelGetUserAddressResponse: AddressesListViewController.ModelGetUserAddressResponse? {
        didSet {
            if modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0 > 0 {
                if let defaultAddressIndex = modelGetUserAddressResponse?.userAddressesResponseData?.firstIndex(where: { model in
                    model.isDefault ?? false
                }) {
                    let latitude = modelGetUserAddressResponse?.userAddressesResponseData?[defaultAddressIndex].latitude ?? 0
                    
                    let longitude = modelGetUserAddressResponse?.userAddressesResponseData?[defaultAddressIndex].longitude ?? 0
                    
                    userLocation = CLLocation(latitude: latitude, longitude: longitude)
                }
                else {
                    print("No default address found.")
                }
                tableView.reloadData()
            }
            else {
                print("User have No address in list.")
                navigateToAddAddressViewController()
            }
        }
    }
    
    var modelGetHomeRestaurantsResponse: ModelGetHomeRestaurantsResponse? {
        didSet {
            if dontTriggerModelGetHomeRestaurantsResponseObservers {
                dontTriggerModelGetHomeRestaurantsResponseObservers = false
                return
            }
            if selectedMenuCell != 0 {
                return()
            }
            let recordFeatureCell = addFeaturedCell()
            listItems[recordFeatureCell.1] = recordFeatureCell.0
            let recordCuisineCell = addCuisineCell()
            listItems[recordCuisineCell.1] = recordCuisineCell.0
            let recordRestuarantCell = addRestuarantCell()
            listItems[recordRestuarantCell.1] = recordRestuarantCell.0
            let recordPrayerPlacesCell = addPrayerPlacesCell()
            listItems[recordPrayerPlacesCell.1] = recordPrayerPlacesCell.0
            
            noRecordFound()
            tableView.reloadData()
        }
    }
    
    var modelGetPrayerPlacesResponse: ModelGetPrayerPlacesResponse? {
        didSet {
            if dontTriggerModelGetHomeRestaurantsResponseObservers {
                dontTriggerModelGetHomeRestaurantsResponseObservers = false
                return
            }
            if selectedMenuCell != 3 {
                return()
            }
            
            let recordCuisineCell = addCuisineCell()
            listItems[recordCuisineCell.1] = recordCuisineCell.0
            let recordPrayerPlacesTabCell = addHomePrayerPlacesTabCell()
            listItems[recordPrayerPlacesTabCell.1] = recordPrayerPlacesTabCell.0
            
            noRecordFound()
            tableView.reloadData()
        }
    }
    
    var modelGetHalalRestaurantResponse: ModelGetHalalRestaurantResponse? {
        didSet {
            if modelGetHalalRestaurantResponse == nil {
                self.tableView.reloadData()
                return
            }
            if dontTriggerModelGetHalalRestaurantResponseObservers {
                dontTriggerModelGetHalalRestaurantResponseObservers = false
                return
            }
            if selectedMenuCell != 1 {
                return()
            }
            let recordCuisineCell = addCuisineCell()
            listItems[0] = recordCuisineCell.0
            let recordFindHalalFoodCell = addFindHalalFoodCell()
            listItems[1] = recordFindHalalFoodCell.0
            
            noRecordFound()
            self.tableView.reloadData()
        }
    }
    
    var modelGetUserResponseLocal: ModelGetUserProfileResponse? {
        didSet {
            sideMenuSetup()
            modelGetUserProfileResponse = modelGetUserResponseLocal
        }
    }

    private var sideMenu: SideMenu!
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    var listItems: [HomeBaseCell.HomeListItem]!
    
    override func viewWillAppear(_ animated: Bool) {
        getuser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfiguration()
    }
    
    func setConfiguration() {
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        sideMenuSetup()
        viewMapViewBackground.circle()
        stackViewFilterResultBackGround.radius(radius: 8)
        stackViewSearchNearLocationBackGround.radius(radius: 8)
        stackViewSearchNTextFieldNearLocationBackGround.radius(radius: 8)
        viewSettingBackGround.radius(radius: 8)
        setStatusBarTopColor(color: .clrMehroonStatusBar)
        textFieldSearchLocation.placeHolderColor(color: .white)
        
        HomeMenuCell.register(collectionView: collectionView)
        HomeFoodItemCell.register(tableView: tableView)
        HomeCuisinesCell.register(tableView: tableView)
        HomeRestaurantCell.register(tableView: tableView)
        HomeSectionHeaderCell.register(tableView: tableView)
        HomePrayerPlacesCell.register(tableView: tableView)
        FindHalalFoodCell.register(tableView: tableView)
        HomePrayerPlacesTabCell.register(tableView: tableView)
        
        //MARK: - Add Extra spacing in tableView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        else {
            // it will fix from properties of table view
        }
        
        NotificationCenter.default.post(name: Notification.Name("kGetUser"), object: nil)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.post(name: Notification.Name("kGetUser"), object: nil)
        
        
        userConfiguration()
        
//        userLocation = CLLocation(latitude: 37.8690971, longitude: -122.2930876)
    }
    
    @IBAction func buttonFilters(_ sender: Any) {
        presentToHomeFilterViewController()
    }
    @IBAction func buttonSideMenu(_ sender: Any) {
        openMenu()
    }
    @IBAction func buttonSearchLocation(_ sender: Any) {
        navigateToEditAddressesViewController()
    }
    @IBAction func buttonMapViewListView(_ sender: Any) {
        buttonMapViewListView.tag = buttonMapViewListView.tag == 0 ? 1 : 0
        setMapList()
    }
    @IBAction func buttonNotification(_ sender: Any) {
    }
    @IBAction func buttonCart(_ sender: Any) {
    }
    
    func sideMenuSetup() {
        let myCustomView: SideMenuView = UIView.fromNib()
        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: myCustomView.frame.width - 80, height: UIScreen.main.bounds.height))
        menuView.addSubview(myCustomView)
        menuView.frame.size.width = myCustomView.frame.width - 80
        
        let menuConfig: MenuConfig = .init(vc: self, customView: menuView)
        sideMenu = .init(menuConfig)
        myCustomView.viewController = self
        myCustomView.buttonBackHandler = closeMenu
        myCustomView.closeMenuHandler = closeMenu
    }
    func openMenu() {
        sideMenu.openMenu()
    }
    func closeMenu() {
        sideMenu.closeMenu()
    }
    func closeMenu(indexPath: IndexPath) {
        closeMenu()
    }
    
    func toggleMenu() {
        sideMenu.toggleMenu()
    }
    
    
    func noRecordFound() {
        return()
        tableView.isHidden = false
        mapView.isHidden = true
        viewNoDataFound.isHidden = true
        if selectedMenuCell == 0 {
            if modelGetHalalRestaurantResponse?.totalPages == nil {
                viewNoDataFound.isHidden = false
                tableView.isHidden = true
                imageViewNoRecordFound.image = UIImage(named: "placeholderRestaurantSubIcon")
                labelNoRecordFound.text = "No Restaurant Found"
            }
            else {
                if modelGetHalalRestaurantResponse?.totalPages == 0 && modelGetHalalRestaurantResponse?.cuisine?.count == 0 {
                    viewNoDataFound.isHidden = false
                    tableView.isHidden = true
                    imageViewNoRecordFound.image = UIImage(named: "placeholderRestaurantSubIcon")
                    labelNoRecordFound.text = "No Restaurant Found"
                }
                else {
                    viewNoDataFound.isHidden = true
                    tableView.isHidden = false
                }
            }
        }
        else if selectedMenuCell == 1 {
            if modelGetHalalRestaurantResponse?.totalPages == nil {
                viewNoDataFound.isHidden = false
                tableView.isHidden = true
                imageViewNoRecordFound.image = UIImage(named: "placeholderHalalFood")
                labelNoRecordFound.text = "No Restaurant Found"
            }
            else {
                if modelGetHalalRestaurantResponse?.totalPages == 0 && modelGetHalalRestaurantResponse?.cuisine?.count == 0 {
                    viewNoDataFound.isHidden = false
                    tableView.isHidden = true
                    imageViewNoRecordFound.image = UIImage(named: "placeholderHalalFood")
                    labelNoRecordFound.text = "No Restaurant Found"
                }
                else {
                    viewNoDataFound.isHidden = true
                    tableView.isHidden = false
                }
            }
        }
        else if selectedMenuCell == 2 {
            
        }
        else if selectedMenuCell == 3 {
            
        }
    }
    
    func handleMenuTap() {
        mapView.clear()
        if selectedMenuCell == 0 {
            viewMapViewBackground.isHidden = true
            //MARK: - Add Items In tableView
            listItems = [
                addFeaturedCell().0,
                addCuisineCell().0,
                addRestuarantCell().0,
                addPrayerPlacesCell().0
            ]
            getFeaturedRestaurants()
        }
        else if selectedMenuCell == 1 {
            listItems = [
                addCuisineCell().0,
                addFindHalalFoodCell().0,
            ]
            pageNumberForApi = 1
        }
        else if selectedMenuCell == 2 {
            listItems = nil
        }
        else if selectedMenuCell == 3 {
            listItems = [
                HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "52 cuisines near you", rowHeight: 100, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
                HomeBaseCell.HomeListItem(identifier: HomePrayerPlacesCell.nibName(), sectionName: "12 prayer spaces near you", rowHeight: 260, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"])
            ]
            pageNumberForApi = 1
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
}





extension HomeViewController: HomeCuisinesCellDelegate {
    func didSelectRow(indexPath: IndexPath, cusisineName: String) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeCuisinesCell.nibName()) {
            print(indexOf)
            mapView.clear()
            modelGetHalalRestaurantResponse = nil
            selectedCuisine = cusisineName
            if selectedMenuCell != 1 {
                selectedMenuCell = indexOf
            }
            else {
                pageNumberForApi = 1
            }
        }
        print("IndexPath For \(HomeCuisinesCell.nibName()): \(indexPath)")
    }
}

extension HomeViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            self.getUserAddress()
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            self.getUserAddress()
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingHeading()
            locationManager.delegate = nil
            self.userLocation = location
            kUserCurrentLocation = location
            print(" Lat \(location.coordinate.latitude) ,  Longitude \(location.coordinate.longitude)")
        }
        if locations.first != nil {
            print("location:: \(locations[0])")
        }
    }
}
