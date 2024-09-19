//
//  HomeViewControllerPresenter.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/08/2024.
//

import Foundation
import Alamofire
import CoreLocation

func showLocationDisabledAlert(viewController: UIViewController) {
    let alert = UIAlertController(title: "Location Services Disabled",
                                  message: "Please enable location services in Settings to use this feature.",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
extension HomeViewController {
   
    
    func navigateToAddAddressViewController() {
        self.labelSearchLocation.text = ""
        self.textFieldSearchLocation.text = ""
        showLocationDisabledAlert(viewController: self)
        return()
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.isFromHomeScreen = true
        vc.newAddressAddedHandler = { (address, location) in
            self.textFieldSearchLocation.text = address
            self.labelSearchLocation.text! = self.textFieldSearchLocation.text!

            self.userLocation = CLLocation(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0)
//            self.getUserAddress()
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
            self.labelSearchLocation.text! = self.textFieldSearchLocation.text!
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
        self.textFieldSearchLocation.text = modelUserAddressesResponseData.physicalAddress
        labelSearchLocation.text! = textFieldSearchLocation.text!
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
        APIs.postAPI(apiName: .mySelf, methodType: .get, encoding: JSONEncoding.default) { responseData, success, errorMsg, statusCode in
            print(responseData ?? "")
            print(success)
            let model: ModelGetUserProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
        }
    }

    func getUserAddress() {
        modelGetUserAddressResponse = modelGetUserResponseLocal?.addresses
//        APIs.postAPI(apiName: .editreview, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
//            let model: AddressesListViewController.ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelGetUserAddressResponse = model
//        }
    }
    
    func userConfiguration() {
        print(getCurrentTimeZone())
        let parameters = [
            "timeZoneId": getCurrentTimeZone()
        ]
        
        APIs.getAPI(apiName: .userConfiguration, parameters: parameters, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelUserConfigurationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelUserConfigurationResponse = model
        }
    }
    
    func getCurrentTimeZone() -> String {
        TimeZone.current.identifier
    }
    
    func textFieldLocationText() -> String {
        let stringWithouTAnyWhitespace = textFieldSearchLocation.text?.filter {!$0.isWhitespace}.lowercased()
        let searchStringPlaceHolder = "Searching around your current location".filter {!$0.isWhitespace}.lowercased()

        if stringWithouTAnyWhitespace != "" &&
            stringWithouTAnyWhitespace != searchStringPlaceHolder {
            return textFieldSearchLocation.text!
        }
        return ""
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //Show Last Cell (for Table View)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedMenuCell == 1 {
            if indexPath.row == ((modelGetHalalRestaurantResponse?.items?.count ?? 0) - 1) {
                print("came to last row")
                pageNumberForApi += 1
            }
        }
        else if selectedMenuCell == 3 {
            if indexPath.row == ((modelGetPrayerPlacesResponse?.items?.count ?? 0) - 1) {
                print("came to last row")
                pageNumberForApi += 1
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleForHeader = (listItems[section]).sectionName
        if titleForHeader == "" {
            return 8
        }
        return 60
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
                return modelGetHalalRestaurantResponse?.items?.count ?? 0
            }
        }
        else if selectedMenuCell == 3 {
            if section == 0 {
                return 1
            }
            else {
                return modelGetPrayerPlacesResponse?.items?.count ?? 0
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
                        cuisineCount =
                        "\(modelGetHalalRestaurantResponseForHomeTab?.totalRecords ?? 0)"
                    }
                    else if section == 3 {
                        cuisineCount = "\(modelGetPrayerPlacesResponseForHomeTab?.totalRecords ?? 0)"
                    }
                }
                else if selectedMenuCell == 1 {
                    cuisineCount = "\(modelGetHalalRestaurantResponse?.totalRecords ?? 0)"
                    
                }
                else if selectedMenuCell == 3 {
                    cuisineCount = "\(modelGetPrayerPlacesResponse?.totalRecords ?? 0)"
                }
                myHeader.viewController = self
                myHeader.cuisineCount = cuisineCount
                myHeader.selectedMenuCell = selectedMenuCell
                myHeader.sectionName = "\((listItems[section]).sectionName ?? "")"
                myHeader.modelGetHomeRestaurantsResponse = modelGetHomeRestaurantsResponseForHome
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
            if let halalRestuarantResponseData =   modelGetHalalRestaurantResponse?.items?[indexPath.row] {
                vc.modelRestuarantResponseData = halalRestuarantResponseData
                modelData = halalRestuarantResponseData
            }
        }
        else if selectedMenuCell == 3 {
            vc.isPrayerPlace = true
            if let mosqueResponseData =   modelGetPrayerPlacesResponse?.items?[indexPath.row] {
                vc.modelRestuarantResponseData = mosqueResponseData
                modelData = mosqueResponseData
            }
        }
        if actionType == "viewdetails" {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if actionType == "mapdirection" {
            let completeAddress = "\(modelData?.address ?? "") \(modelData?.city ?? "") \(modelData?.state ?? "") \(modelData?.country ?? "")"
            OpenMapDirections.present(in: self, sourceView: buttonCart, latitude: modelData?.latitude ?? 0, longitude: modelData?.longitude ?? 0, locationAddress: completeAddress)
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
        textFieldFilterResult.text = nil
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
            var featuredRestuarantResponseData = [ModelRestuarantResponseData?]()
            featuredRestuarantResponseData = modelGetHomeRestaurantsResponseForHome?.items ?? []
            
            print(indexOf)
            let recordCount = featuredRestuarantResponseData.count
            if recordCount > 0 {
                let data = featuredRestuarantResponseData as Any
                let rowHeight = 224
                let identifier = HomeFoodItemCell.nibName()
                var address = ""
                if textFieldLocationText() != "" {
                    let array = textFieldSearchLocation.text?.split(separator: ",") ?? []
                    if array.count > 1 {
                        // Concatenate the first and second elements with a space in between
                        if array.count > 3 {
                            address = "\(array[0]), \(array[1])"
                        }
                        else {
                            address = "\(array[0])"
                        }
                        print(address)  // This will print the concatenated address
                    } 
                    else if array.count > 0 {
                        address = "\(array[0])"
                    }
                    else {
                        print("The array does not contain enough elements.")
                    }
                }
                
                let sectionName =  address == "" ? "Featured near you" : "Featured near \(address)"
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    
    func addRestuarantCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomeRestaurantCell.nibName()) {
            var restuarantResponseData = [ModelRestuarantResponseData?]()
            restuarantResponseData = modelGetHalalRestaurantResponseForHomeTab?.items ?? []
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
    
    func addPrayerPlacesHomeTabCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomePrayerPlacesCell.nibName()) {
            var mosqueResponseData = [ModelRestuarantResponseData?]()
            mosqueResponseData = modelGetPrayerPlacesResponseForHomeTab?.items ?? []
            print(indexOf)
            let recordCount = mosqueResponseData.count
            if recordCount > 0 {
                let data = mosqueResponseData as Any
                let rowHeight = 224
                let identifier = HomePrayerPlacesCell.nibName()
                var address = ""
                if textFieldLocationText() != "" {
                    let array = textFieldSearchLocation.text?.split(separator: ",") ?? []
                    if array.count > 1 {
                        // Concatenate the first and second elements with a space in between
                        if array.count > 3 {
                            address = "\(array[0]), \(array[1])"
                        }
                        else {
                            address = "\(array[0])"
                        }
                        print(address)  // This will print the concatenated address
                    }
                    else if array.count > 0 {
                        address = "\(array[0])"
                    }
                    else {
                        print("The array does not contain enough elements.")
                    }
                }
                let space = modelGetPrayerPlacesResponseForHomeTab?.totalRecords ?? 0 > 1 ? "spaces" : "space"
                let sectionName =  address == "" ? 
                "\(selectedCuisine == "" ? "prayer" : selectedCuisine + " prayer") \(space) near you" : "\(selectedCuisine == "" ? "prayer" : selectedCuisine  + " prayer") \(space) near \(address)"
                
                let record = HomeBaseCell.HomeListItem(identifier: identifier , sectionName: sectionName, rowHeight: rowHeight, data: data)
                return (record, indexOf, recordCount)
            }
        }
        return (HomeBaseCell.HomeListItem(identifier: HomePrayerPlacesCell.nibName(), sectionName: "", rowHeight: 0, data: nil), 0, 0)
    }
    
    func addHomePrayerPlacesTabCell() -> (HomeBaseCell.HomeListItem, _indexOf: Int, _record: Int) {
        if let indexOf = findIndexOfIdentifier(identifier: HomePrayerPlacesTabCell.nibName()) {
            var mosqueResponseData = [ModelRestuarantResponseData?]()
            mosqueResponseData = modelGetPrayerPlacesResponse?.items ?? []
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
            var modelHalalRestuarantResponseData = [ModelRestuarantResponseData?]()
            modelHalalRestuarantResponseData = modelGetHalalRestaurantResponse?.items ?? []
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
                let allUniqueCuisines = getAllUniqueCuisines(items: modelGetHalalRestaurantResponseForHomeTab?.items)
                cuisine = allUniqueCuisines
                var address = ""
                if textFieldLocationText() != "" {
                    let array = textFieldSearchLocation.text?.split(separator: ",") ?? []
                    if array.count > 1 {
                        // Concatenate the first and second elements with a space in between
                        if array.count > 3 {
                            address = "\(array[0]), \(array[1])"
                        }
                        else {
                            address = "\(array[0])"
                        }
                        print(address)  // This will print the concatenated address
                    }
                    else if array.count > 0 {
                        address = "\(array[0])"
                    }
                    else {
                        print("The array does not contain enough elements.")
                    }
                }
                
                sectionName =
                address == "" ? "restaurants near you"
                :
                "\(selectedCuisine == "" ? "restaurants" : selectedCuisine) near \(address)"
//                selectedPlaceHolderIcon = "placeHolderSubCuisine"
                selectedPlaceHolderIcon = "placeholderHalalFood"
            }
            else if selectedMenuCell == 1 {
                let allUniqueCuisines = modelCuisinesHalal
                cuisine = allUniqueCuisines ?? []
                var address = ""
                if textFieldLocationText() != "" {
                    let array = textFieldSearchLocation.text?.split(separator: ",") ?? []
                    if array.count > 1 {
                        // Concatenate the first and second elements with a space in between
                        if array.count > 3 {
                            address = "\(array[0]), \(array[1])"
                        }
                        else {
                            address = "\(array[0])"
                        }
                        print(address)  // This will print the concatenated address
                    }
                    else if array.count > 0 {
                        address = "\(array[0])"
                    }
                    else {
                        print("The array does not contain enough elements.")
                    }
                }
                
                let places = modelGetHalalRestaurantResponse?.totalRecords ?? 0 > 1 ? "places" : "place"
                sectionName = 
                address == "" ?
                "\(selectedCuisine == "" ? "halal" : selectedCuisine) \(places) near you"
                :
                "\(selectedCuisine == "" ? "halal \(places)" : "\(selectedCuisine) \(places)") near \(address)"
                
                selectedPlaceHolderIcon = "placeholderHalalFood"
            }
            else if selectedMenuCell == 3 {
                let allUniqueCuisines = getAllUniqueCuisines(items: modelGetPrayerPlacesResponse?.items)
                cuisine = modelCuisinesPrayerPlaces ?? []
//                sectionName = "\(selectedCuisine == "" ? "" : selectedCuisine + " ")prayer spaces near you"
                
                var address = ""
                if textFieldLocationText() != "" {
                    let array = textFieldSearchLocation.text?.split(separator: ",") ?? []
                    if array.count > 1 {
                        // Concatenate the first and second elements with a space in between
                        if array.count > 3 {
                            address = "\(array[0]), \(array[1])"
                        }
                        else {
                            address = "\(array[0])"
                        }
                        print(address)  // This will print the concatenated address
                    }
                    else if array.count > 0 {
                        address = "\(array[0])"
                    }
                    else {
                        print("The array does not contain enough elements.")
                    }
                }
                
                let places = modelGetPrayerPlacesResponse?.totalRecords ?? 0 > 1 ? "spaces" : "space"
                
                sectionName =  
                address == "" ? "\(selectedCuisine == "" ? "prayer" : selectedCuisine + "") \(places) near you" : "\(selectedCuisine == "" ? "prayer" : selectedCuisine + "") \(places) near \(address)"
                selectedPlaceHolderIcon = "placeholderMosque3"

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
//                modelGetHomeRestaurantsResponse?.items?[indexPath.row].isFavorites = isFavourite
            }
            else if indexPath.section == 2 {
//                modelGetHomeRestaurantsResponse?.restuarantResponseData?[indexPath.row].isFavorites = isFavourite
            }
            else if indexPath.section == 3 {
//                modelGetHomeRestaurantsResponse?.mosqueResponseData?[indexPath.row].isFavorites = isFavourite
            }
            else {
                selectedMenuCell = itself(selectedMenuCell)
            }
        }
        else if selectedMenuCell == 1 {
//            modelGetHalalRestaurantResponse?.halalRestuarantResponseData?[indexPath.row].isFavorites = isFavourite
        }
        else if selectedMenuCell == 2 {
            
        }
        else if selectedMenuCell == 3 {
//            modelGetPrayerPlacesResponse?.mosqueResponseData?[indexPath.row].isFavorites = isFavourite
        }
    }
    
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UICollectionViewCell) {
        dontTriggerModelGetHomeRestaurantsResponseObservers = true
        if self.selectedMenuCell == 0 {
            if cellType is HomeFoodItemSubCell {
                self.modelGetHomeRestaurantsResponseForHome?.items?[indexPath.item]?.isMyFavorite = isFavourite
            }
        }
        else if cellType is HomeRestaurantSubCell {
            self.modelGetHalalRestaurantResponseForHomeTab?.items?[indexPath.item]?.isMyFavorite = isFavourite
        }
        else if cellType is HomePrayerSpacesSubCell {
            self.modelGetPrayerPlacesResponseForHomeTab?.items?[indexPath.item]?.isMyFavorite = isFavourite
        }
        else if self.selectedMenuCell == 1 {
            self.modelGetHalalRestaurantResponse?.items?[indexPath.item]?.isMyFavorite = isFavourite
        }
        else if self.selectedMenuCell == 3 {
            self.modelGetPrayerPlacesResponse?.items?[indexPath.item]?.isMyFavorite = isFavourite
        }
    }
    
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UITableViewCell) {
        if selectedMenuCell == 1 {
//            modelGetHalalRestaurantResponse?.halalRestuarantResponseData?[indexPath.item].isFavorites = isFavourite
        }
        else if selectedMenuCell == 3 {
//            modelGetPrayerPlacesResponse?.mosqueResponseData?[indexPath.item].isFavorites = isFavourite
        }
    }
}
