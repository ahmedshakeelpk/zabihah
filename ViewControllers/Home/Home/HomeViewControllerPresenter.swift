//
//  HomeViewControllerPresenter.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/08/2024.
//

import Foundation
import Alamofire
import CoreLocation

extension HomeViewController {
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        
        vc.newAddressAddedHandler = {
            self.getUserAddress()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToEditAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        vc.addressFromPreviousScreen = textFieldSearchLocation.text!
        vc.location = CLLocationCoordinate2D(latitude: userLocation?.coordinate.latitude ?? 0, longitude: userLocation?.coordinate.longitude ?? 0)
        vc.isDisableUpdateLocation = true
        vc.buttonContinueHandler = { (address, location) in
            print(location as Any)
            self.textFieldSearchLocation.text = address
            self.userLocation = CLLocation(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentToHomeFilterViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "HomeFilterViewController") as! HomeFilterViewController
        if userLocation == nil {
            return()
        }
        vc.selectedMenuCell = selectedMenuCell
        vc.location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        vc.buttonFilterHandler = { parameters in
            print(parameters)
            self.filterParametersHome = parameters
            self.mapView.clear()
            if self.selectedMenuCell == 0 {
//                self.getFeaturedRestaurants()
                self.selectedMenuCell = self.itself(self.selectedMenuCell)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.selectedMenuCell = self.itself(self.selectedMenuCell)
                }
            }
            else if self.selectedMenuCell == 1 {
                self.selectedCuisine = ""
                self.pageNumberForApi = 1
            }
            else if self.selectedMenuCell == 3 {
                self.selectedCuisine = ""
                self.selectedMenuCell = self.itself(self.selectedMenuCell)
                
            }
        }
        vc.filterParametersHome = filterParametersHome
        vc.selectedMenuCell = selectedMenuCell
        self.present(vc, animated: true)
    }
    
    func selectedAddress(modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData) {
        let model = modelUserAddressesResponseData
        self.userLocation = CLLocation(latitude: model.latitude ?? 0, longitude: model.longitude ?? 0)
        self.textFieldSearchLocation.text = modelUserAddressesResponseData.address
    }
    
    func setMapList() {
        if buttonMapViewListView.tag == 1 {
            viewMapViewBackGround.isHidden = false
            tableView.isHidden = true
            imageViewListViewMapView.image = UIImage(named: "listViewHome")
            labelMapViewListView.text = "List View"
        }
        else {
            viewMapViewBackGround.isHidden = true
            tableView.isHidden = false
            buttonMapViewListView.tag = 0
            imageViewListViewMapView.image = UIImage(named: "mapViewHome")
            labelMapViewListView.text = "Map View"
        }
    }
    
    
    func buttonViewAllHandler(section: Int) {
        if section == 1 {
            filterParametersHome = nil
            selectedCuisine = ""
            selectedMenuCell = section
            collectionView.reloadData()
        }
        else if section == 3 {
            filterParametersHome = nil
            selectedCuisine = ""
            selectedMenuCell = section
            collectionView.reloadData()
        }
    }
    
    func getuser() {
        APIs.postAPI(apiName: .getuser, methodType: .get, encoding: JSONEncoding.default) { responseData, success, errorMsg in
            print(responseData ?? "")
            print(success)
            let model: ModelGetUserProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
        }
    }
    
    func getFeaturedRestaurants() {
        var parameters = [
            "lat": userLocation?.coordinate.latitude as Any,
            "long": userLocation?.coordinate.longitude as Any,
            "radius": 20,
            "rating": 0,
            "isalcoholic": false,
            "isHalal": true
        ]
        
        if filterParametersHome != nil {
            let radius = filterParametersHome["radius"] as? String
            parameters["radius"] = Int(radius ?? "0")
            let rating = filterParametersHome["rating"] as? String
            parameters["rating"] = Int(rating ?? "0")
            let isAlCoholic = filterParametersHome["isalcoholic"] as? Bool
            parameters["isalcoholic"] = isAlCoholic
            let isHalal = filterParametersHome["isHalal"] as? Bool
            parameters["isHalal"] = isHalal
        }
        
        APIs.postAPI(apiName: .gethomerestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetHomeRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetHomeRestaurantsResponse = nil
            self.modelGetHomeRestaurantsResponse = model
        }
    }
        
    func getHalalRestaurants(pageSize: Int, cuisine: String) {
        var parameters = [
            "lat": userLocation?.coordinate.latitude ?? 0,
            "long": userLocation?.coordinate.longitude ?? 0,
            "radius": 20,
            "rating": 0,
            "isalcoholic": false,
            "isHalal": true,
            "page": Int(pageSize),
            "pageSize": 0,
            "cuisine": cuisine
        ] as [String : Any]
        
        
        if filterParametersHome != nil {
            let radius = filterParametersHome["radius"] as? String
            parameters["radius"] = Int(radius ?? "0")
            let rating = filterParametersHome["rating"] as? String
            parameters["rating"] = Int(rating ?? "0")
            let isAlCoholic = filterParametersHome["isalcoholic"] as? Bool
            parameters["isalcoholic"] = isAlCoholic
            let isHalal = filterParametersHome["isHalal"] as? Bool
            parameters["isHalal"] = isHalal
        }
        
        APIs.postAPI(apiName: .gethalalrestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            var model: ModelGetHalalRestaurantResponse? = APIs.decodeDataToObject(data: responseData)
            
            if self.pageNumberForApi > 1 {
                if let record = self.modelGetHalalRestaurantResponse?.halalRestuarantResponseData {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.halalRestuarantResponseData ?? [])
                    model?.halalRestuarantResponseData = oldModel
                }
            }
            self.modelGetHalalRestaurantResponse = model
        }
    }
    
    func getPrayerPlaces(pageSize: Int) {
        var parameters = [
            "lat": userLocation?.coordinate.latitude ?? 0,
            "long": userLocation?.coordinate.longitude ?? 0,
            "radius": 20,
            "rating": 0,
            "page": Int(pageSize),
            "pageSize": 0,
            "type": selectedCuisine
        ] as [String : Any]
        
        if filterParametersHome != nil {
            let radius = filterParametersHome["radius"] as? String
            parameters["radius"] = Int(radius ?? "0")
            let rating = filterParametersHome["rating"] as? String
            parameters["rating"] = Int(rating ?? "0")
        }
        
        APIs.postAPI(apiName: .getprayerplaces, parameters: parameters, encoding: JSONEncoding.default, viewController: self) { responseData, success, errorMsg in
            var model: ModelGetPrayerPlacesResponse? = APIs.decodeDataToObject(data: responseData)
            if self.pageNumberForApi > 1 {
                if let record = self.modelGetPrayerPlacesResponse?.mosqueResponseData {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.mosqueResponseData ?? [])
                    model?.mosqueResponseData = oldModel
                }
            }
            self.modelGetPrayerPlacesResponse = model
        }
    }

    func getUserAddress() {
        APIs.postAPI(apiName: .getuseraddress, methodType: .get, viewController: self) { responseData, success, errorMsg in
            let model: AddressesListViewController.ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
    
    func userConfiguration() {
        print(getCurrentTimeZone())
        let parameters: Parameters = [
            "timeZoneId": getCurrentTimeZone()
        ]
        APIs.postAPI(apiName: .userConfiguration, parameters: parameters, methodType: .post, viewController: self) { responseData, success, errorMsg in
            let model: ModelUserConfigurationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelUserConfigurationResponse = model
        }
    }
    
    func getCurrentTimeZone() -> String {
        TimeZone.current.identifier
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //Show Last Cell (for Table View)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedMenuCell == 1 {
            if indexPath.row == ((modelGetHalalRestaurantResponse?.halalRestuarantResponseData?.count ?? 0) - 1) {
                print("came to last row")
                pageNumberForApi += 1
            }
        }
        else if selectedMenuCell == 3 {
            if indexPath.row == ((modelGetPrayerPlacesResponse?.mosqueResponseData?.count ?? 0) - 1) {
                print("came to last row")
                pageNumberForApi += 1
            }
        }
        cell.layoutSubviews()
        cell.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleForHeader = (listItems[section]).sectionName
        if titleForHeader == "" {
            return 8
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
        else if selectedMenuCell == 1 {
            if section == 0 {
                return 1
            }
            else {
                return modelGetHalalRestaurantResponse?.halalRestuarantResponseData?.count ?? 0
            }
        }
        else if selectedMenuCell == 3 {
            if section == 0 {
                return 1
            }
            else {
                return modelGetPrayerPlacesResponse?.mosqueResponseData?.count ?? 0
            }
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (listItems[indexPath.section]).identifier) as! HomeBaseCell
        print((listItems[indexPath.section]).identifier)
        print(indexPath.section)
        cell.updateCell(data: listItems[indexPath.section], indexPath: indexPath, viewController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCell") as? HomeSectionHeaderCell {
            myHeader.section = section
            if myHeader.labelTitle != nil {
                var cuisineCount = ""
                if selectedMenuCell == 0 {
                    if section == 1 {
                        cuisineCount = "\(modelGetHomeRestaurantsResponse?.totalCountHalal ?? 0)"
                    }
                    else if section == 3 {
                        cuisineCount = "\(modelGetHomeRestaurantsResponse?.totalPrayerSpaces ?? 0)"
                    }
                }
                else if selectedMenuCell == 1 {
                    cuisineCount = "\(modelGetHalalRestaurantResponse?.totalCountHalal ?? 0)"
                    
                }
                else if selectedMenuCell == 3 {
                    cuisineCount = "\(modelGetPrayerPlacesResponse?.totalMosque ?? 0)"
                }
                myHeader.viewController = self
                myHeader.cuisineCount = cuisineCount
                myHeader.selectedMenuCell = selectedMenuCell
                myHeader.sectionName = "\((listItems[section]).sectionName ?? "")"
                myHeader.modelGetHomeRestaurantsResponse = modelGetHomeRestaurantsResponse
                myHeader.modelGetHalalRestaurantResponse = modelGetHalalRestaurantResponse
                myHeader.buttonViewAllHandler = buttonViewAllHandler
            }
            return myHeader
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedMenuCell == 1 || selectedMenuCell == 3 {
            navigateToDeliveryDetailsViewController(indexPath: indexPath, actionType: "viewdetails")
        }
    }
    
    func navigateToDeliveryDetailsViewController(indexPath: IndexPath, actionType: String) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
        vc.delegate = self
        vc.indexPath = indexPath
        vc.selectedMenuCell = selectedMenuCell
        vc.userLocation = userLocation
        
        var modelData: ModelRestuarantResponseData!
        if selectedMenuCell == 1 {
            if let halalRestuarantResponseData =   modelGetHalalRestaurantResponse?.halalRestuarantResponseData?[indexPath.row] {
                vc.modelRestuarantResponseData = halalRestuarantResponseData
                modelData = halalRestuarantResponseData
            }
        }
        else if selectedMenuCell == 3 {
            vc.isPrayerPlace = true
            if let mosqueResponseData =   modelGetPrayerPlacesResponse?.mosqueResponseData?[indexPath.row] {
                vc.modelRestuarantResponseData = mosqueResponseData
                modelData = mosqueResponseData
            }
        }
        if actionType == "viewdetails" {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if actionType == "mapdirection" {
            OpenMapDirections.present(in: self, sourceView: buttonCart, latitude: modelData?.latitude ?? 0, longitude: modelData?.longitude ?? 0, locationName: modelData?.address ?? "")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 10
        if collectionView == self.collectionView {
            width = collectionView.frame.width / 4
        }
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
        if arrayNames[indexPath.item].lowercased() == "Pickup & delivery".lowercased() {
            return()
        }
        filterParametersHome = nil
        selectedCuisine = ""
        mapView.clear()
        selectedMenuCell = indexPath.item
    }
}

extension HomeViewController {
    func findIndexOfIdentifier(identifier: String) -> Int? {
        let indexOf = listItems?.map { $0.identifier }.firstIndex { identifierLocal in
            identifierLocal == identifier
        }
        return indexOf
    }
    
    func addCellInList() {
        viewMapViewBackground.isHidden = false
        viewMapViewBackGround.isHidden = true
        buttonMapViewListView.tag = 0
        setMapList()
        listItems = []
        listItems = [
            HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomeRestaurantCell.nibName(), sectionName: "", rowHeight: 224, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomePrayerPlacesCell.nibName(), sectionName: "12 prayer spaces near you", rowHeight: 224, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
            HomeBaseCell.HomeListItem(identifier: FindHalalFoodCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomePrayerPlacesTabCell.nibName(), sectionName: "", rowHeight: 0, data: nil)
        ]
        tableViewReload()
    }
    
    func addFeaturedCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeFoodItemCell.nibName()) {
            var featuredRestuarantResponseData = [ModelRestuarantResponseData]()
            featuredRestuarantResponseData = modelGetHomeRestaurantsResponse?.featuredRestuarantResponseData ?? []
            
            print(indexOf)
            let recordCount = featuredRestuarantResponseData.count
            if recordCount > 0 {
                let data = featuredRestuarantResponseData as Any
                let rowHeight = 224
                let identifier = HomeFoodItemCell.nibName()
                let sectionName = "Featured near you"
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    
    func addRestuarantCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeRestaurantCell.nibName()) {
            var restuarantResponseData = [ModelRestuarantResponseData]()
            restuarantResponseData = modelGetHomeRestaurantsResponse?.restuarantResponseData ?? []
            print(indexOf)
            let recordCount = restuarantResponseData.count
            if recordCount > 0 {
                let data = restuarantResponseData as Any
                let rowHeight = 224
                let identifier = HomeRestaurantCell.nibName()
                let sectionName = ""
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeRestaurantCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    
    func addPrayerPlacesCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomePrayerPlacesCell.nibName()) {
            var mosqueResponseData = [ModelRestuarantResponseData]()
            mosqueResponseData = modelGetHomeRestaurantsResponse?.mosqueResponseData ?? []
            print(indexOf)
            let recordCount = mosqueResponseData.count
            if recordCount > 0 {
                let data = mosqueResponseData as Any
                let rowHeight = 224
                let identifier = HomePrayerPlacesCell.nibName()
                let sectionName = "prayer spaces near you"
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomePrayerPlacesCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    
    func addHomePrayerPlacesTabCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomePrayerPlacesTabCell.nibName()) {
            var mosqueResponseData = [ModelRestuarantResponseData]()
            mosqueResponseData = modelGetPrayerPlacesResponse?.mosqueResponseData ?? []
            print(indexOf)
            let recordCount = mosqueResponseData.count
            if recordCount > 0 {
                let data = mosqueResponseData as Any
                let rowHeight = 256
                let identifier = HomePrayerPlacesTabCell.nibName()
                let sectionName = ""
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomePrayerPlacesTabCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    
    
    func addFindHalalFoodCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: FindHalalFoodCell.nibName()) {
            var modelHalalRestuarantResponseData = [ModelRestuarantResponseData]()
            modelHalalRestuarantResponseData = modelGetHalalRestaurantResponse?.halalRestuarantResponseData ?? []
            
            print(indexOf)
            let recordCount = modelHalalRestuarantResponseData.count
            if recordCount > 0 {
                let data = modelHalalRestuarantResponseData as Any
                let rowHeight = 260
                let identifier = FindHalalFoodCell.nibName()
                let sectionName = ""
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: FindHalalFoodCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    func addCuisineCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeCuisinesCell.nibName()) {
            var sectionName = ""
            var selectedPlaceHolderIcon = ""
            var cuisine = [ModelCuisine]()
            
            if selectedMenuCell == 0 {
                cuisine = modelGetHomeRestaurantsResponse?.cuisine ?? []
                sectionName = "halal places near you"
                selectedPlaceHolderIcon = "placeHolderSubCuisine"
            }
            else if selectedMenuCell == 1 {
                cuisine = modelGetHalalRestaurantResponse?.cuisine ?? []
                sectionName = "halal places near you"
                selectedPlaceHolderIcon = "placeholderHalalFood"
            }
            else if selectedMenuCell == 3 {
                cuisine = modelGetPrayerPlacesResponse?.mosqueTypes ?? []
                sectionName = "prayer spaces near you"
                selectedPlaceHolderIcon = "markerPrayerPlacesSelected"
            }
            print(indexOf)
            let recordCount = cuisine.count
            if recordCount > 0 {
                let data =  [
                    "data": cuisine as Any,
                    "selectedCuisine": selectedCuisine,
                    "selectedPlaceHolderIcon": selectedPlaceHolderIcon
                ]
                
                let rowHeight = 120
                let identifier = HomeCuisinesCell.nibName()
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 1, 0)
    }
}

extension HomeViewController: HomeFoodItemSubCellDelegate, FindHalalFoodCellDelegate, HomeRestaurantSubCellDelegate, HomePrayerSpacesSubCellDelegate, DeliveryDetailsViewController3Delegate, HomePrayerPlacesTabCellDelegate {
  
    func changeFavouriteStatusFromDetails(isFavourite: Bool, indexPath: IndexPath) {
        if selectedMenuCell == 0 {
            if indexPath.section == 0 {
                modelGetHomeRestaurantsResponse?.featuredRestuarantResponseData?[indexPath.row].isFavorites = isFavourite
            }
            else if indexPath.section == 2 {
                modelGetHomeRestaurantsResponse?.restuarantResponseData?[indexPath.row].isFavorites = isFavourite
            }
            else if indexPath.section == 3 {
                modelGetHomeRestaurantsResponse?.mosqueResponseData?[indexPath.row].isFavorites = isFavourite
            }
            else {
                selectedMenuCell = itself(selectedMenuCell)
            }
        }
        else if selectedMenuCell == 1 {
            modelGetHalalRestaurantResponse?.halalRestuarantResponseData?[indexPath.row].isFavorites = isFavourite
        }
        else if selectedMenuCell == 2 {
            
        }
        else if selectedMenuCell == 3 {
            modelGetPrayerPlacesResponse?.mosqueResponseData?[indexPath.row].isFavorites = isFavourite
        }
    }
    
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UICollectionViewCell) {
//        dontTriggerModelGetHomeRestaurantsResponseObservers = true
        if cellType is HomeFoodItemSubCell {
            modelGetHomeRestaurantsResponse?.featuredRestuarantResponseData?[indexPath.item].isFavorites = isFavourite
        }
        else if cellType is HomeRestaurantSubCell {
            modelGetHomeRestaurantsResponse?.restuarantResponseData?[indexPath.item].isFavorites = isFavourite
        }
        else if cellType is HomePrayerSpacesSubCell {
            modelGetHomeRestaurantsResponse?.mosqueResponseData?[indexPath.item].isFavorites = isFavourite
        }
    }
    
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UITableViewCell) {
        if selectedMenuCell == 1 {
            modelGetHalalRestaurantResponse?.halalRestuarantResponseData?[indexPath.item].isFavorites = isFavourite
        }
        else if selectedMenuCell == 3 {
            modelGetPrayerPlacesResponse?.mosqueResponseData?[indexPath.item].isFavorites = isFavourite
        }
    }
}
