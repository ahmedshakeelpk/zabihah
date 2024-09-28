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

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelSectionName: UILabel!
    @IBOutlet weak var viewSectionNameBackGround: UIView!
    @IBOutlet weak var stackViewTitleBackGround: UIStackView!
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
    @IBOutlet weak var textFieldSearchLocation: UITextField! {
        didSet {
        }
    }
    @IBOutlet weak var labelSearchLocation: UILabel!
    
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
            DispatchQueue.main.async {
                kModelUserConfigurationResponse = self.modelUserConfigurationResponse
                self.locationManager.delegate = self
                self.checkLocationServices()
            }
            //Location Services
        }
    }
    
    var filterParametersHome: ModelFilterRequest?
    
    var selectedMenuCell: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.addCellInList()
                self.handleMenuTap()
            }
        }
    }
    var pageNumberForApi: Int! = 1 {
        didSet {
            DispatchQueue.main.async {
                
                if self.selectedMenuCell == 0 {
                    
                }
                else if self.selectedMenuCell == 1 {
                    if self.pageNumberForApi == 0 {
                        return
                    }
                    if self.pageNumberForApi > 1 {
                        if self.pageNumberForApi > self.modelGetHalalRestaurantResponse?.totalPages ?? 0 {
                            return()
                        }
                    }
                    self.getHalalRestaurants(pageSize: self.pageNumberForApi, cuisine: self.selectedCuisine)
                }
                else if self.selectedMenuCell == 3 {
                    if self.pageNumberForApi == 0 {
                        return
                    }
                    if self.pageNumberForApi > 1 {
                        if self.pageNumberForApi > self.modelGetPrayerPlacesResponse?.totalPages ?? 0 {
                            return()
                        }
                    }
                    self.getPrayerPlaces(pageSize: self.pageNumberForApi)
                }
            }
        }
    }
    
    var userLocation: CLLocation! {
        didSet {
            DispatchQueue.main.async {
                //                kUserCurrentLocation = self.userLocation
                
                getCountryFromCoordinates(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude, completion: {
                    countryName in
                    if countryName?.lowercased() == "United States".lowercased() {
                        kCountryName = "us"
                    }
                    else {
                        kCountryName = countryName ?? ""
                    }
                    self.filterParametersHome = nil
                    self.self.selectedMenuCell = self.itself(self.selectedMenuCell)
                })
            }
        }
    }
    
    var dontTriggerModelGetHomeRestaurantsResponseObservers:Bool = false
    var dontTriggerModelGetHalalRestaurantResponseObservers:Bool = false
    
    var modelGetUserAddressResponse: [AddressesListViewController.ModelUserAddressesResponseData]? {
        didSet {
            DispatchQueue.main.async {
                if self.modelGetUserAddressResponse?.count ?? 0 > 0 {
                    if let defaultAddressIndex = self.modelGetUserAddressResponse?.firstIndex(where: { model in
                        model.isDefault ?? false
                    }) {
                        let latitude = self.modelGetUserAddressResponse?[defaultAddressIndex].latitude ?? 0
                        
                        let longitude = self.modelGetUserAddressResponse?[defaultAddressIndex].longitude ?? 0
                        
                        self.userLocation = CLLocation(latitude: latitude, longitude: longitude)
                        
                        let userDefaultAddress = self.modelGetUserAddressResponse?[defaultAddressIndex].physicalAddress
                        
                        self.textFieldSearchLocation.text = userDefaultAddress
                        self.labelSearchLocation.text! = self.textFieldSearchLocation.text!
                        
                    }
                    else {
                        print("No default address found.")
                    }
                    self.tableViewReload()
                }
                else {
                    print("User have No address in list.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigateToAddAddressViewController()
                    }
                }
            }
        }
    }
    
    var modelCuisinesPrayerPlaces: [ModelCuisine]? {
        didSet {
            DispatchQueue.main.async {
                if self.selectedMenuCell != 1 {
                    return()
                }
                let recordCuisineCell = self.addCuisineCell()
                self.listItems[0] = recordCuisineCell.0
                let recordFindHalalFoodCell = self.addFindHalalFoodCell()
                self.listItems[1] = recordFindHalalFoodCell.0
                self.tableViewReload()
            }
        }
    }
    var modelGetPrayerPlacesResponse: ModelFeaturedResponse? {
        didSet {
            DispatchQueue.main.async {
                if self.dontTriggerModelGetHomeRestaurantsResponseObservers {
                    self.dontTriggerModelGetHomeRestaurantsResponseObservers = false
                    return
                }
                if self.selectedMenuCell != 3 {
                    return()
                }
                
                let recordCuisineCell = self.addCuisineCell()
                self.listItems[0] = recordCuisineCell.0
                let recordPrayerPlacesTabCell = self.addHomePrayerPlacesTabCell()
                self.listItems[1] = recordPrayerPlacesTabCell.0
                self.tableViewReload()
                self.mapView.clear()
                if let modelData = self.modelGetPrayerPlacesResponse?.items {
                    for (index, model) in modelData.enumerated() {
                        if let model = model {
                            self.drawMarkerOnMapPrayerPlaces(modelRestuarantResponseData: model, index: index)
                        }
                    }
                }
            }
        }
    }
    
    
    var modelGetHomeRestaurantsResponseForHome: ModelFeaturedResponse? {
        didSet {
            DispatchQueue.main.async {
                if self.modelGetHomeRestaurantsResponseForHome == nil {
                    self.tableViewReload()
                    return
                }
                if self.dontTriggerModelGetHomeRestaurantsResponseObservers {
                    self.dontTriggerModelGetHomeRestaurantsResponseObservers = false
                    return
                }
                if self.selectedMenuCell != 0 {
                    return()
                }
                self.setDataForHomeTab()
            }
        }
    }
    var modelGetHalalRestaurantResponseForHomeTab: ModelFeaturedResponse? {
        didSet {
            DispatchQueue.main.async {
                if self.modelGetHalalRestaurantResponseForHomeTab == nil {
                    self.tableViewReload()
                    return
                }
                if self.dontTriggerModelGetHalalRestaurantResponseObservers {
                    self.dontTriggerModelGetHalalRestaurantResponseObservers = false
                    return
                }
                if self.selectedMenuCell != 0 {
                    return()
                }
                self.setDataForHomeTab()
            }
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
            DispatchQueue.main.async {
                if self.modelGetPrayerPlacesResponseForHomeTab == nil {
                    self.tableViewReload()
                    return
                }
                if self.dontTriggerModelGetHomeRestaurantsResponseObservers {
                    self.dontTriggerModelGetHomeRestaurantsResponseObservers = false
                    return
                }
                if self.selectedMenuCell != 3 {
                    return()
                }
                self.setDataForHomeTab()
            }
        }
    }
    
    var modelCuisinesHalal: [ModelCuisine]? {
        didSet {
            DispatchQueue.main.async {
                if self.selectedMenuCell != 1 {
                    return()
                }
                let recordCuisineCell = self.addCuisineCell()
                self.listItems[0] = recordCuisineCell.0
                let recordFindHalalFoodCell = self.addFindHalalFoodCell()
                self.listItems[1] = recordFindHalalFoodCell.0
                self.tableViewReload()
            }
        }
    }
    
    var modelGetHalalRestaurantResponse: ModelFeaturedResponse? {
        didSet {
            DispatchQueue.main.async {
                if self.modelGetHalalRestaurantResponse == nil {
                    self.tableViewReload()
                    return
                }
                if self.dontTriggerModelGetHalalRestaurantResponseObservers {
                    self.dontTriggerModelGetHalalRestaurantResponseObservers = false
                    return
                }
                if self.selectedMenuCell != 1 {
                    return()
                }
                let recordCuisineCell = self.addCuisineCell()
                self.listItems[0] = recordCuisineCell.0
                let recordFindHalalFoodCell = self.addFindHalalFoodCell()
                self.listItems[1] = recordFindHalalFoodCell.0
                self.tableViewReload()
                self.mapView.clear()
                if let modelData = self.modelGetHalalRestaurantResponse?.items {
                    for (index, model) in modelData.enumerated() {
                        self.drawMarkerOnMap(modelRestuarantResponseData: model!, index: index)
                    }
                }
            }
        }
    }
    
    
    var modelGetUserResponseLocal: ModelGetUserProfileResponse? {
        didSet {
            DispatchQueue.main.async {
                self.sideMenuSetup()
                kModelGetUserProfileResponse = self.modelGetUserResponseLocal
                NotificationCenter.default.post(name: Notification.Name("kUserProfileUpdate"), object: nil)
            }
        }
    }
    
    private var sideMenu: SideMenu!
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    var listItems: [HomeBaseCell.HomeListItem]!
    var pullControl = UIRefreshControl()
    
    override func viewDidAppear(_ animated: Bool) {
        
        setStatusBarTopColor(color: .tempColor)
        
        mapView.isMyLocationEnabled = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 8)
    }
    
    @objc func pulledRefreshControl() {
        if textFieldSearchLocation.text?.lowercased() == "Searching around your current location".lowercased() {
            locationManager.delegate = self
            checkLocationServices()
        }
        else {
            selectedMenuCell = itself(selectedMenuCell)
        }
        //        textFieldSearchLocation.text = "Searching around your current location"
        
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
        viewSectionNameBackGround.isHidden = true
        mapView.delegate = self
        
        tableView.addSubview(pullControl) // not
        tableView.refreshControl?.tintColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        
        stackViewTitleBackGround.backgroundColor = .colorApp
        
        stackViewSearchNearLocationBackGround.backgroundColor = .colorMehroon
        sideMenuSetup()
        viewZoomInBackGround.circle()
        viewZoomOutBackGround.circle()
        viewItemCountOnMapViewBackGround.circle()
        viewMapViewBackground.circle()
        stackViewFilterResultBackGround.radius(radius: 8)
        stackViewSearchNearLocationBackGround.radius(radius: 8)
        stackViewSearchNTextFieldNearLocationBackGround.radius(radius: 8)
        viewSettingBackGround.radius(radius: 8)
        textFieldSearchLocation.placeHolderColor(color: .clear)
        
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
        
        textFieldFilterResult.addTarget(self, action: #selector(searchTextFieldFilterResult), for: .editingChanged)
        
        userConfiguration()
        setZoomButtons()
        //        userLocation = CLLocation(latitude: 37.8690971, longitude: -122.2930876)
    }
    
    var isFilterSearch = false
    @objc func searchTextFieldFilterResult() {
        if isFilterSearch {
            return()
        }
        isFilterSearch = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            self.isFilterSearch = false
            self.selectedMenuCell = self.itself(self.selectedMenuCell)
        }
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
        if selectedMenuCell == 0 {
            let featureRestaurant = modelGetHomeRestaurantsResponseForHome?.totalRecords
            let halalRestaurant = modelGetHalalRestaurantResponseForHomeTab?.totalRecords
            let prayerPlaces = modelGetPrayerPlacesResponseForHomeTab?.totalRecords
            imageViewNoRecordFound.image = UIImage(named: "placeholderRestaurantSubIcon")
            labelNoRecordFound.text = "No Restaurant Found"
            if featureRestaurant == 0 && halalRestaurant == 0 && prayerPlaces == 0 {
                viewNoDataFound.isHidden = false
                tableView.isHidden = true
            }
            else {
                viewNoDataFound.isHidden = true
                tableView.isHidden = false
            }
        }
        else if selectedMenuCell == 1 {
            imageViewNoRecordFound.image = UIImage(named: "chefPlaceHolder")
            labelNoRecordFound.text = "No Restaurant Found"
            if modelGetHalalRestaurantResponse?.totalRecords == 0 {
                viewNoDataFound.isHidden = false
                tableView.isHidden = true
                viewMapViewBackground.isHidden = true
            }
            else {
                viewNoDataFound.isHidden = true
                viewMapViewBackground.isHidden = false
                if buttonMapViewListView.tag != 1 {
                    self.tableView.isHidden = false
                }
            }
        }
        else if selectedMenuCell == 2 {
            
        }
        else if selectedMenuCell == 3 {
            imageViewNoRecordFound.image = UIImage(named: "placeholderMosque")
            labelNoRecordFound.text = "No Prayer Places Found"
            if modelGetPrayerPlacesResponse?.totalRecords == 0 {
                viewNoDataFound.isHidden = false
                tableView.isHidden = true
                viewMapViewBackground.isHidden = true
            }
            else {
                viewNoDataFound.isHidden = true
                viewMapViewBackground.isHidden = false
                if buttonMapViewListView.tag != 1 {
                    self.tableView.isHidden = false
                }
            }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        detectVisibleSections()
    }
    
    func detectVisibleSections() {
        // Get the visible rows' index paths
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            
            // Get the first visible index path (which gives us the section of the first visible row)
            if let firstVisibleIndexPath = visibleIndexPaths.first {
                let visibleSection = firstVisibleIndexPath.section
                
                // Detect when a certain section becomes visible
                print("Currently viewing Section: \(visibleSection)")
                
                // Example: if you want to detect when Section 2 becomes visible
                if visibleSection == 2 {
                    print("Section 2 has come into view!")
                }
                print("Section \(visibleSection)")
                let titleForHeader = (listItems[visibleSection]).sectionName
                labelSectionName.text = "\(titleForHeader ?? "")"
            }
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




