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
    var userLocation: CLLocation! {
        didSet {
            if selectedMenuCell == 0 {
                getFeaturedRestaurants()
            }
            else if selectedMenuCell == 1 {
                getHalalRestaurants(pageSize: 0, cuisine: "")
            }
        }
    }

    var modelGetHomeRestaurantsResponse: ModelGetHomeRestaurantsResponse? {
        didSet {
            let recordFeatureCell = addFeaturedCell()
            var indexPathArray = [IndexPath]()
            var indexSetArray = [Int]()
            if recordFeatureCell.2 > 0 {
                listItems[recordFeatureCell.1] = recordFeatureCell.0
                let indexPath = IndexPath(row: 0, section: recordFeatureCell.1)
                indexPathArray.append(indexPath)
                indexSetArray.append(recordFeatureCell.1)
            }
            
            let recordCuisineCell = addCuisineCell()
            if recordCuisineCell.2 > 0 {
                listItems[recordCuisineCell.1] = recordCuisineCell.0
                let indexPath = IndexPath(row: 0, section: recordCuisineCell.1)
                indexPathArray.append(indexPath)
                indexSetArray.append(recordCuisineCell.1)
            }
            
//            self.tableView.reloadRows(at: indexPathArray, with: .none)
            for item in indexSetArray {
                self.tableView.reloadSections(IndexSet(integer: item), with: .automatic)
            }
        }
    }
    
    var modelGetHalalRestaurantResponse: ModelGetHalalRestaurantResponse? {
        didSet {
            let recordFeatureCell = addFeaturedCell()
            var indexPathArray = [IndexPath]()
            var indexSetArray = [Int]()
            if recordFeatureCell.2 > 0 {
                listItems[recordFeatureCell.1] = recordFeatureCell.0
                let indexPath = IndexPath(row: 0, section: recordFeatureCell.1)
                indexPathArray.append(indexPath)
                indexSetArray.append(recordFeatureCell.1)
            }
            
            let recordCuisineCell = addCuisineCell()
            if recordCuisineCell.2 > 0 {
                listItems[recordCuisineCell.1] = recordCuisineCell.0
                let indexPath = IndexPath(row: 0, section: recordCuisineCell.1)
                indexPathArray.append(indexPath)
                indexSetArray.append(recordCuisineCell.1)
            }
            
//            self.tableView.reloadRows(at: indexPathArray, with: .none)
            for item in indexSetArray {
                self.tableView.reloadSections(IndexSet(integer: item), with: .automatic)
            }
            if indexSetArray.count == 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    var modelGetUserResponseLocal: ModelGetUserProfileResponse? {
        didSet {
            modelGetUserProfileResponse = modelGetUserResponseLocal
            sideMenuSetup()
        }
    }
    func addCellInList() {
        viewMapViewBackground.isHidden = false
        listItems = [
            HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
        HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
        HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 240, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
        HomeBaseCell.HomeListItem(identifier: HomePrayerSpacesCell.nibName(), sectionName: "12 prayer spaces near you", rowHeight: 240, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"])
        ]
    }
    var selectedMenuCell: Int = 0 {
        didSet {
            addCellInList()
            if selectedMenuCell == 0 {
                viewMapViewBackground.isHidden = true
                //MARK: - Add Items In tableView
                listItems = [
                    addFeaturedCell().0,
                    addCuisineCell().0,
                ]
            }
            else if selectedMenuCell == 1 {
                listItems = [
                    addCuisineCell().0,
                    addFeaturedCell().0,
                ]
            }
            else if selectedMenuCell == 2 {
                listItems = nil
            }
            else if selectedMenuCell == 3 {
                listItems = [
                    HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "52 cuisines near you", rowHeight: 100, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
                    HomeBaseCell.HomeListItem(identifier: HomePrayerSpacesCell.nibName(), sectionName: "12 prayer spaces near you", rowHeight: 260, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"])
                ]
            }
            tableView.reloadData()
            collectionView.reloadData()
        }
    }

    private var sideMenu: SideMenu!
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    var listItems: [HomeBaseCell.HomeListItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfiguration()
        getuser()
        getFeaturedRestaurants()
    }
    
    func setConfiguration() {
        mapView.delegate = self
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
        HomeSectionHeaderCell.register(tableView: tableView)
        HomePrayerSpacesCell.register(tableView: tableView)
        FindHalalFoodCell.register(tableView: tableView)
        
        //MARK: - Add Extra spacing in tableView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        else {
            // it will fix from properties of table view
        }
        selectedMenuCell = 0
        
        NotificationCenter.default.post(name: Notification.Name("kGetUser"), object: nil)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.post(name: Notification.Name("kGetUser"), object: nil)
        
        //Location Services
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        userLocation = CLLocation(latitude: 37.8690971, longitude: -122.2930876)
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
        if buttonMapViewListView.tag == 0 {
            mapView.isHidden = false
            tableView.isHidden = true
            buttonMapViewListView.tag = 1
            imageViewListViewMapView.image = UIImage(named: "listViewHome")
            labelMapViewListView.text = "List View"
        }
        else {
            mapView.isHidden = true
            tableView.isHidden = false
            buttonMapViewListView.tag = 0
            imageViewListViewMapView.image = UIImage(named: "mapViewHome")
            labelMapViewListView.text = "Map View"
        }
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
    
    func navigateToEditAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentToHomeFilterViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "HomeFilterViewController") as! HomeFilterViewController
        vc.location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        vc.buttonFilterHandler = { parameters in
            print(parameters)
            self.getFeaturedRestaurants(parameters: parameters)
        }
        self.present(vc, animated: true)
    }
    
    func selectedAddress(modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData) {
        let model = modelUserAddressesResponseData
        self.userLocation = CLLocation(latitude: model.latitude ?? 0, longitude: model.longitude ?? 0)
        self.textFieldSearchLocation.text = modelUserAddressesResponseData.address
    }
    
    func getuser() {       
        APIs.postAPI(apiName: .getuser, methodType: .get, encoding: JSONEncoding.default) { responseData, success, errorMsg in
            print(responseData ?? "")
            print(success)
            let model: ModelGetUserProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
        }
    }
    
    func getFeaturedRestaurants(parameters: [String: Any]? = nil) {
        var parameters = parameters
        if parameters == nil {
            parameters = [
                "lat": userLocation?.coordinate.latitude as Any,
                "long": userLocation?.coordinate.longitude as Any,
                "radius": 0,
                "rating": 0,
                "isalcoholic": false,
                "isHalal": true
            ]
        }
        else {
            parameters?["lat"] = userLocation?.coordinate.latitude as Any
            parameters?["long"] = userLocation?.coordinate.longitude as Any
        }
        APIs.postAPI(apiName: .gethomerestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetHomeRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetHomeRestaurantsResponse = model
        }
    }
    
    func getHalalRestaurants(pageSize: Int, cuisine: String, parameters: [String: Any]? = nil) {
        let parameters = [
            "lat": userLocation?.coordinate.latitude as Any,
            "long": userLocation?.coordinate.longitude as Any,
            "radius": 0,
            "rating": 0,
            "isalcoholic": false,
            "isHalal": true,
            "page": 0,
            "pageSize": 0,
            "cuisine": cuisine
        ] as [String : Any]
        
        APIs.postAPI(apiName: .gethalalrestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetHalalRestaurantResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetHalalRestaurantResponse = model
        }
    }
    
    func buttonViewAllHandler(section: Int) {
        if section == 1 {
            selectedMenuCell = section
            collectionView.reloadData()
            getHalalRestaurants(pageSize: 0, cuisine: "")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 10
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCell", for: indexPath) as! HomeMenuCell
        cell.labelName.text = arrayNames[indexPath.item]
        cell.selectedCell(selectedMenuCell: selectedMenuCell, indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMenuCell = indexPath.item
        if selectedMenuCell == 1 {
            collectionView.reloadData()
            getHalalRestaurants(pageSize: 0, cuisine: "")
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleForHeader = (listItems[section]).sectionName
        if titleForHeader == "" {
            return 20
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRow = (listItems[indexPath.section]).rowHeight ?? 0
        return CGFloat(heightForRow)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if listItems == nil {
            return 0
        }
        if selectedMenuCell == 0 {
            return listItems.count
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listItems == nil {
            return 0
        }
        if selectedMenuCell == 0 {
            return 1
        }
        else {
            if section == 0 {
                return 1
            }
            else {
                return 5
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (listItems[indexPath.section]).identifier) as! HomeBaseCell
        if selectedMenuCell == 0 {
            print((listItems[indexPath.section]).identifier)
        }
        else {
            print((listItems[indexPath.section]).identifier)
        }
        print(indexPath.section)

        cell.updateCell(data: listItems[indexPath.section], indexPath: indexPath, viewController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCell") as? HomeSectionHeaderCell {
            myHeader.section = section
            if myHeader.labelTitle != nil {
                myHeader.modelGetHomeRestaurantsResponse = modelGetHomeRestaurantsResponse
                myHeader.sectionName = "\((listItems[section]).sectionName ?? "")"
                myHeader.buttonViewAllHandler = buttonViewAllHandler
            }
            return myHeader
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    }
}

extension HomeViewController: HomeCuisinesCellDelegate {
    func didSelectRow(indexPath: IndexPath) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeCuisinesCell.nibName()) {
            print(indexOf)
            selectedMenuCell = indexOf
            getHalalRestaurants(pageSize: 0, cuisine: modelGetHomeRestaurantsResponse?.cuisine?[indexPath.item].name ?? "")
        }
        print("IndexPath For \(HomeCuisinesCell.nibName()): \(indexPath)")
    }
}


extension HomeViewController {
    func findIndexOfIdentifier(identifier: String) -> Int? {
        let indexOf = listItems?.map { $0.identifier }.firstIndex { identifierLocal in
            identifierLocal == identifier
        }
        return indexOf
    }
    
    func addFeaturedCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeFoodItemCell.nibName()) {
            var featuredRestuarantResponseData = [ModelRestuarantResponseData]()
            if selectedMenuCell == 0 {
                featuredRestuarantResponseData = modelGetHomeRestaurantsResponse?.featuredRestuarantResponseData ?? []
            }
            else if selectedMenuCell == 1 {
                featuredRestuarantResponseData = modelGetHalalRestaurantResponse?.halalRestuarantResponseData ?? []
            }
            
            print(indexOf)
            let recordCount = featuredRestuarantResponseData.count
            if recordCount > 0 {
                let data = featuredRestuarantResponseData as Any
                let rowHeight = 240
                let identifier = HomeFoodItemCell.nibName()
                let sectionName = "Featured near you"
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    func addCuisineCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeCuisinesCell.nibName()) {
            var cuisine = [ModelCuisine]()
            if selectedMenuCell == 0 {
                cuisine = modelGetHomeRestaurantsResponse?.cuisine ?? []
            }
            else if selectedMenuCell == 1 {
                cuisine = modelGetHalalRestaurantResponse?.cuisine ?? []
            }
            
            print(indexOf)
            let recordCount = cuisine.count
            if recordCount > 0 {
                let data = cuisine as Any
                let rowHeight = 120
                let identifier = HomeCuisinesCell.nibName()
                let sectionName = " cuisines near you"
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 1, 0)
    }
}
extension HomeViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.userLocation = location
            print(" Lat \(location.coordinate.latitude) ,  Longitude \(location.coordinate.longitude)")
        }
        if locations.first != nil {
            print("location:: \(locations[0])")
        }

    }

}
