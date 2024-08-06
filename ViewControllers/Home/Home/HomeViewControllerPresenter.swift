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
        vc.location = CLLocationCoordinate2D(latitude: userLocation?.coordinate.latitude ?? 0, longitude: userLocation?.coordinate.longitude ?? 0)
        
        vc.buttonContinueHandler = { (address, location) in
            print(location as Any)
            self.userLocation = CLLocation(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0)
            self.textFieldSearchLocation.text = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentToHomeFilterViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "HomeFilterViewController") as! HomeFilterViewController
        if userLocation?.coordinate.latitude == nil && userLocation?.coordinate.longitude == nil {
            return()
        }
        vc.location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        vc.buttonFilterHandler = { parameters in
            print(parameters)
            if self.selectedMenuCell == 0 {
                self.getFeaturedRestaurants(parameters: parameters)
            }
            if self.selectedMenuCell == 1 {
                self.parametersHalalFood = parameters
                self.selectedCuisine = ""
            }
        }
        self.present(vc, animated: true)
    }
    
    func selectedAddress(modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData) {
        let model = modelUserAddressesResponseData
        self.userLocation = CLLocation(latitude: model.latitude ?? 0, longitude: model.longitude ?? 0)
        self.textFieldSearchLocation.text = modelUserAddressesResponseData.address
    }
    
    func setMapList() {
        if buttonMapViewListView.tag == 1 {
            mapView.isHidden = false
            tableView.isHidden = true
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
    
    
    func buttonViewAllHandler(section: Int) {
        if section == 1 {
            selectedMenuCell = section
            collectionView.reloadData()
            parametersHalalFood = nil
            selectedCuisine = ""
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
    
    func getFeaturedRestaurants(parameters: [String: Any]? = nil) {
        var parameters = parameters
        if parameters == nil {
            parameters = [
                "lat": userLocation?.coordinate.latitude as Any,
                "long": userLocation?.coordinate.longitude as Any,
//                "radius": 50,
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
        var parameters = parameters
        if parameters == nil {
            parameters = [
                "lat": userLocation?.coordinate.latitude ?? 0,
                "long": userLocation?.coordinate.longitude ?? 0,
    //            "radius": 50,
                "rating": 0,
                "isalcoholic": false,
                "isHalal": true,
                "page": Int(pageSize),
                "pageSize": 0,
                "cuisine": cuisine
            ]
        }
        else {
            parameters?["lat"] = userLocation?.coordinate.latitude as Any
            parameters?["long"] = userLocation?.coordinate.longitude as Any
        }
        APIs.postAPI(apiName: .gethalalrestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            var model: ModelGetHalalRestaurantResponse? = APIs.decodeDataToObject(data: responseData)
            
            if self.pageNumberHalalFood > 1 {
                if let record = self.modelGetHalalRestaurantResponse?.halalRestuarantResponseData {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.halalRestuarantResponseData ?? [])
                    model?.halalRestuarantResponseData = oldModel
                }
            }
            self.modelGetHalalRestaurantResponse = model
        }
    }

    func getUserAddress() {
        APIs.postAPI(apiName: .getuseraddress, methodType: .get, viewController: self) { responseData, success, errorMsg in
            let model: AddressesListViewController.ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    
    //Show Last Cell (for Table View)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedMenuCell == 1 {
            if indexPath.row == ((modelGetHalalRestaurantResponse?.halalRestuarantResponseData?.count ?? 0) - 1) {
                print("came to last row")
                pageNumberHalalFood += 1
            }
        }
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
                myHeader.modelGetHomeRestaurantsResponse = modelGetHomeRestaurantsResponse
                myHeader.modelGetHalalRestaurantResponse = modelGetHalalRestaurantResponse
                myHeader.sectionName = "\((listItems[section]).sectionName ?? "")"
                myHeader.buttonViewAllHandler = buttonViewAllHandler
                myHeader.selectedMenuCell = selectedMenuCell
            }
            return myHeader
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 10
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
        
        if collectionView == collectionView {
            selectedMenuCell = indexPath.item
            if selectedMenuCell == 1 {
                self.parametersHalalFood = nil
                selectedCuisine = ""
            }
        }
        else {
            self.parametersHalalFood = nil
            selectedCuisine = ""
            print("other cell")
        }
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
        mapView.isHidden = true
        buttonMapViewListView.tag = 0
        setMapList()
        listItems = [
            HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "", rowHeight: 0, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomeRestaurantCell.nibName(), sectionName: "", rowHeight: 240, data: nil),
            HomeBaseCell.HomeListItem(identifier: HomePrayerSpacesCell.nibName(), sectionName: "12 prayer spaces near you", rowHeight: 240, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
            HomeBaseCell.HomeListItem(identifier: FindHalalFoodCell.nibName(), sectionName: "", rowHeight: 0, data: nil)
        ]
    }
    
    func addFeaturedCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeFoodItemCell.nibName()) {
            var featuredRestuarantResponseData = [ModelRestuarantResponseData]()
            featuredRestuarantResponseData = modelGetHomeRestaurantsResponse?.featuredRestuarantResponseData ?? []
            
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
    
    func addRestuarantCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeRestaurantCell.nibName()) {
            var restuarantResponseData = [ModelRestuarantResponseData]()
            restuarantResponseData = modelGetHomeRestaurantsResponse?.restuarantResponseData ?? []
            print(indexOf)
            let recordCount = restuarantResponseData.count
            if recordCount > 0 {
                let data = restuarantResponseData as Any
                let rowHeight = 240
                let identifier = HomeRestaurantCell.nibName()
                let sectionName = ""
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeRestaurantCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
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
                let data =  [
                    "data": cuisine as Any,
                    "selectedCuisine": selectedCuisine
                ]
                
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



extension HomeViewController: HomeFoodItemSubCellDelegate, FindHalalFoodCellDelegate, HomeRestaurantSubCellDelegate {
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UICollectionViewCell) {
//        dontTriggerModelGetHomeRestaurantsResponseObservers = true
        if cellType is HomeFoodItemSubCell {
            modelGetHomeRestaurantsResponse?.featuredRestuarantResponseData?[indexPath.item].isFavorites = isFavourite
        }
        else if cellType is HomeRestaurantSubCell {
            modelGetHomeRestaurantsResponse?.restuarantResponseData?[indexPath.item].isFavorites = isFavourite
        }
    }
    
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UITableViewCell) {
//        dontTriggerModelGetHalalRestaurantResponseObservers = true
        modelGetHalalRestaurantResponse?.halalRestuarantResponseData?[indexPath.item].isFavorites = isFavourite
    }
}
