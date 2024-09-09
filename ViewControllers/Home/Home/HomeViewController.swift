//
//  HomeViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewItemCountOnMapViewBackGround: UIView!
    @IBOutlet weak var labelItemCountOnMapView: UILabel!
    @IBOutlet weak var imageViewNoRecordFound: UIImageView!
    @IBOutlet weak var labelNoRecordFound: UILabel!
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var viewMapViewBackGround: UIView!
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
    @IBOutlet weak var viewZoomInBackGround: UIView!
    @IBOutlet weak var buttonSearchLocation: UIButton!
    @IBOutlet weak var buttonZoomIn: UIButton!
    @IBOutlet weak var viewZoomOutBackGround: UIView!
    @IBOutlet weak var buttonZoomOut: UIButton!
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
            kModelUserConfigurationResponse = modelUserConfigurationResponse
            locationManager.delegate = self
            checkLocationServices()
        }
    }
    
    var filterParametersHome: ModelFilterRequest?
    
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
                    if pageNumberForApi > modelGetPrayerPlacesResponse?.totalPages ?? 0 {
                        return()
                    }
                }
                getPrayerPlaces(pageSize: pageNumberForApi)
            }
        }
    }
    
    var userLocation: CLLocation! {
        didSet {
            filterParametersHome = nil
            self.selectedMenuCell = itself(selectedMenuCell)
        }
    }

    var dontTriggerModelGetHomeRestaurantsResponseObservers:Bool = false
    var dontTriggerModelGetHalalRestaurantResponseObservers:Bool = false

    var modelGetUserAddressResponse: [AddressesListViewController.ModelUserAddressesResponseData]? {
        didSet {
            if modelGetUserAddressResponse?.count ?? 0 > 0 {
                if let defaultAddressIndex = modelGetUserAddressResponse?.firstIndex(where: { model in
                    model.isDefault ?? false
                }) {
                    let latitude = modelGetUserAddressResponse?[defaultAddressIndex].latitude ?? 0
                    
                    let longitude = modelGetUserAddressResponse?[defaultAddressIndex].longitude ?? 0
                    
                    userLocation = CLLocation(latitude: latitude, longitude: longitude)
                }
                else {
                    print("No default address found.")
                }
                tableViewReload()
            }
            else {
                print("User have No address in list.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigateToAddAddressViewController()
                }
            }
        }
    }
    
    var modelGetPrayerPlacesResponse: ModelFeaturedResponse? {
        didSet {
            if dontTriggerModelGetHomeRestaurantsResponseObservers {
                dontTriggerModelGetHomeRestaurantsResponseObservers = false
                return
            }
            if selectedMenuCell != 3 {
                return()
            }
            
            let recordCuisineCell = addCuisineCell()
            listItems[0] = recordCuisineCell.0
            let recordPrayerPlacesTabCell = addHomePrayerPlacesTabCell()
            listItems[1] = recordPrayerPlacesTabCell.0
            
            tableViewReload()
            mapView.clear()
            if let modelData = modelGetPrayerPlacesResponse?.items {
                for (index, model) in modelData.enumerated() {
                    if let model = model {
                        drawMarkerOnMap(modelRestuarantResponseData: model, index: index)
                    }
                }
            }
        }
    }
    
    
    var modelGetHomeRestaurantsResponseForHome: ModelFeaturedResponse? {
        didSet {
            if modelGetHomeRestaurantsResponseForHome == nil {
                self.tableViewReload()
                return
            }
            if dontTriggerModelGetHomeRestaurantsResponseObservers {
                dontTriggerModelGetHomeRestaurantsResponseObservers = false
                return
            }
            if selectedMenuCell != 0 {
                return()
            }
            setDataForHomeTab()
        }
    }
    var modelGetHalalRestaurantResponseForHomeTab: ModelFeaturedResponse? {
        didSet {
            if modelGetHalalRestaurantResponseForHomeTab == nil {
                self.tableViewReload()
                return
            }
            if dontTriggerModelGetHalalRestaurantResponseObservers {
                dontTriggerModelGetHalalRestaurantResponseObservers = false
                return
            }
            if selectedMenuCell != 0 {
                return()
            }
            
            setDataForHomeTab()
        }
    }
    
    func setDataForHomeTab() {
        let recordFeatureCell = addFeaturedCell()
        listItems[0] = recordFeatureCell.0
        let recordCuisineCell = addCuisineCell()
        listItems[1] = recordCuisineCell.0
        let recordRestuarantCell = addRestuarantCell()
        listItems[2] = recordRestuarantCell.0
        let recordPrayerPlacesCell = addPrayerPlacesHomeTabCell()
        listItems[3] = recordPrayerPlacesCell.0
        tableViewReload()
    }
    
    var modelGetPrayerPlacesResponseForHomeTab: ModelFeaturedResponse? {
        didSet {
            if modelGetPrayerPlacesResponseForHomeTab == nil {
                self.tableViewReload()
                return
            }
            if dontTriggerModelGetHomeRestaurantsResponseObservers {
                dontTriggerModelGetHomeRestaurantsResponseObservers = false
                return
            }
            if selectedMenuCell != 3 {
                return()
            }
            setDataForHomeTab()
        }
    }
    
    var modelGetHalalRestaurantResponse: ModelFeaturedResponse? {
        didSet {
            if modelGetHalalRestaurantResponse == nil {
                self.tableViewReload()
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
            tableViewReload()
            mapView.clear()
            if let modelData = modelGetHalalRestaurantResponse?.items {
                for (index, model) in modelData.enumerated() {
                    drawMarkerOnMap(modelRestuarantResponseData: model!, index: index)
                }
            }
        }
    }
    
    
    var modelGetUserResponseLocal: ModelGetUserProfileResponse? {
        didSet {
            sideMenuSetup()
            kModelGetUserProfileResponse = modelGetUserResponseLocal
        }
    }

    private var sideMenu: SideMenu!
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    var listItems: [HomeBaseCell.HomeListItem]!
    
    var pullControl = UIRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
           tableView.addSubview(pullControl) // not
        tableView.refreshControl?.tintColor = .clear
    }
    @objc func pulledRefreshControl() {
        
        textFieldSearchLocation.text = "Searching around your current location"
        locationManager.delegate = self
        checkLocationServices()
//        selectedMenuCell = itself(selectedMenuCell)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pullControl.endRefreshing()
        }
    }
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
        viewZoomInBackGround.circle()
        viewZoomOutBackGround.circle()
        viewItemCountOnMapViewBackGround.circle()
        viewMapViewBackground.circle()
        stackViewFilterResultBackGround.radius(radius: 8)
        stackViewSearchNearLocationBackGround.radius(radius: 8)
        stackViewSearchNTextFieldNearLocationBackGround.radius(radius: 8)
        viewSettingBackGround.radius(radius: 8)
        setStatusBarTopColor(color: .colorApp)
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

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
        setZoomButtons()
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
    
    func setZoomButtons() {
        // Add Zoom Out button
        buttonZoomOut.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        
        // Add Zoom In button
        buttonZoomIn.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
    }
    
    @objc func zoomIn() {
            let zoom = mapView.camera.zoom + 1
            mapView.animate(toZoom: zoom)
        }

        @objc func zoomOut() {
            let zoom = mapView.camera.zoom - 1
            mapView.animate(toZoom: zoom)
            pageNumberForApi += 1
        }
    
    func tableViewReload() {
        tableView.reloadData()
        return()
        if tableView.visibleCells.count == 0 {
            viewNoDataFound.isHidden = false
            tableView.isHidden = true
            imageViewNoRecordFound.image = UIImage(named: "placeholderRestaurantSubIcon")
            labelNoRecordFound.text = "No Restaurant Found"
        }
        else {
            viewNoDataFound.isHidden = true
            tableView.isHidden = true
        }
        return()
        if selectedMenuCell == 0 {
            if modelGetHalalRestaurantResponse?.totalPages == nil {
                viewNoDataFound.isHidden = false
                tableView.isHidden = true
                imageViewNoRecordFound.image = UIImage(named: "placeholderRestaurantSubIcon")
                labelNoRecordFound.text = "No Restaurant Found"
            }
            else {
//                if modelGetHalalRestaurantResponse?.totalPages == 0 && modelGetHalalRestaurantResponse?.cuisine?.count == 0 {
//                    viewNoDataFound.isHidden = false
//                    tableView.isHidden = true
//                    imageViewNoRecordFound.image = UIImage(named: "placeholderRestaurantSubIcon")
//                    labelNoRecordFound.text = "No Restaurant Found"
//                }
//                else {
//                    viewNoDataFound.isHidden = true
//                    tableView.isHidden = false
//                }
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
//                if modelGetHalalRestaurantResponse?.totalPages == 0 && modelGetHalalRestaurantResponse?.cuisine?.count == 0 {
//                    viewNoDataFound.isHidden = false
//                    tableView.isHidden = true
//                    imageViewNoRecordFound.image = UIImage(named: "placeholderHalalFood")
//                    labelNoRecordFound.text = "No Restaurant Found"
//                }
//                else {
//                    viewNoDataFound.isHidden = true
//                    tableView.isHidden = false
//                }
            }
        }
        else if selectedMenuCell == 2 {
            
        }
        else if selectedMenuCell == 3 {
            
        }
    }
    
    func homeTabApisCall() {
        self.getFeaturedRestaurantsForHomeTab()
        self.getHalalRestaurantsForHomeTab()
        self.getPrayerPlacesForHomeTab()
        
//        let dispatchGroup = DispatchGroup()
//        // Dispatch function1
//        dispatchGroup.enter()
//        DispatchQueue.global().async {
//            self.getFeaturedRestaurantsForHomeTab()
//            dispatchGroup.leave()
//        }
//
//        // Dispatch function2
//        dispatchGroup.enter()
//        DispatchQueue.global().async {
//            self.getHalalRestaurantsForHomeTab()
//            dispatchGroup.leave()
//        }
//
//        // Dispatch function3
//        dispatchGroup.enter()
//        DispatchQueue.global().async {
//            self.getPrayerPlacesForHomeTab()
//            dispatchGroup.leave()
//        }
//
//        // Notify when all functions are done
//        dispatchGroup.notify(queue: DispatchQueue.main) {
//            print("All functions are done")
//        }
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
                addPrayerPlacesHomeTabCell().0
            ]
            homeTabApisCall()
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
                addCuisineCell().0,
                addHomePrayerPlacesTabCell().0
            ]
            pageNumberForApi = 1
        }
        tableViewReload()
        collectionView.reloadData()
    }
    
    func checkLocationServices() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.requestWhenInUseAuthorization()
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
}

extension HomeViewController: HomeCuisinesCellDelegate {
    func didSelectRow(indexPath: IndexPath, cusisineName: String) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeCuisinesCell.nibName()) {
            print(indexOf)
            mapView.clear()
            modelGetHalalRestaurantResponse = nil
            selectedCuisine = cusisineName
            if selectedMenuCell == 0 {
                selectedMenuCell = indexOf
            }
            else if selectedMenuCell == 1 || selectedMenuCell == 3 {
                pageNumberForApi = 1
            }
            else if selectedMenuCell == 2 {
                
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
        getUserAddress()
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


