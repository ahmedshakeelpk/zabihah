//
//  FindHalalFoodCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 21/07/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol FindHalalFoodCellDelegate: AnyObject {
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UITableViewCell)
}

class FindHalalFoodCell: HomeBaseCell {
    struct ModelPostFavouriteRestaurantsResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
    }
    
    @IBOutlet weak var stackViewComments: UIStackView!
    @IBOutlet weak var stackViewReturning: UIStackView!
    @IBOutlet weak var stackViewPhotos: UIStackView!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var viewBackGroundDelivery: UIView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var viewCallMainBackGround: UIView!
    @IBOutlet weak var labelRestaurantAddress: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelReuse: UILabel!
    @IBOutlet weak var labelPictures: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var viewItemTypeBackGround: UIView!
    @IBOutlet weak var labelItemType: UILabel!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewBikeBackGround: UIView!
    @IBOutlet weak var viewCallBackGround: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var stackViewFavouriteBackGround: UIStackView!
    @IBOutlet weak var stackViewRatingBackGround: UIStackView!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var buttonOpenDirectionMap: UIButton!
    
    var arrayNames = [String]()
    let arrayIconNames = ["home", "chefHatHome", "Pickup & delivery", "Prayer spaces"]
    
    var dataRecord: HomeBaseCell.HomeListItem!
    var delegate: FindHalalFoodCellDelegate!
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            if let isFavourite = self.restuarentResponseModel?.isMyFavorite {
                DispatchQueue.main.async {
                    self.delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: self.indexPath, cellType: FindHalalFoodCell())
                }
                restuarentResponseModel?.isMyFavorite = !(isFavourite)
            }
        }
    }
    
    var restuarentResponseModel: HomeViewController.ModelRestuarantResponseData? {
        didSet {
            DispatchQueue.main.async {
                self.setData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 12)
        viewBikeBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewCallBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 0)
        viewRatingBackGround.radius(radius: 4)
        viewItemTypeBackGround.circle()
        
        HomeFoodItemSubCuisineCell.register(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        imageViewRestaurant.circle()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        super.updateCell(data: data, indexPath: indexPath, viewController: viewController)
        // Configure the view for the selected state
        dataRecord = data as? HomeBaseCell.HomeListItem
        if let modelData = dataRecord.data as? [HomeViewController.ModelRestuarantResponseData] {
            restuarentResponseModel = modelData[indexPath.row]
        }
        collectionView.reloadData()
        drawMarkerOnMap()
    }

    @IBAction func buttonOpenDirectionMap(_ sender: Any) {
        let completeAddress = "\(restuarentResponseModel?.name ?? "") \(restuarentResponseModel?.address ?? "") \(restuarentResponseModel?.city ?? "") \(restuarentResponseModel?.state ?? "") \(restuarentResponseModel?.country ?? "")"
        OpenMapDirections.present(in: viewController, sourceView: buttonOpenDirectionMap, latitude: restuarentResponseModel?.latitude ?? 0, longitude: restuarentResponseModel?.longitude ?? 0, locationAddress: completeAddress)
    }
    
    @IBAction func buttonCall(_ sender: Any) {
        self.viewController.dialNumber(isPrayerPlaces: false, name: "", number: restuarentResponseModel?.phone ?? "")
    }
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any FindHalalFoodCellDelegate
        favouriteRestaurants()
    }
    
    func drawMarkerOnMap() {
//        /// Marker - Google Place marker
//        let marker: GMSMarker = GMSMarker() // Allocating Marker
//        marker.title = halalRestuarantResponseData?.name // Setting title
//        marker.snippet = halalRestuarantResponseData?.address // Setting sub title
//        marker.icon = UIImage(named: "markerHome") // Marker icon
//        marker.appearAnimation = .pop // Appearing animation. default
//        marker.userData = halalRestuarantResponseData
//        
        let location = CLLocationCoordinate2D(latitude: restuarentResponseModel?.latitude ?? 0, longitude: restuarentResponseModel?.longitude ?? 0)
//        marker.position = location
//        marker.map = (viewController as? HomeViewController)?.mapView // Setting marker on Mapview
        setZoom(location: location)
    }
    
    func setZoom(location: CLLocationCoordinate2D) {
        let lat = location.latitude
        let long = location.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        (viewController as? HomeViewController)?.mapView.camera = camera
        (viewController as? HomeViewController)?.mapView.delegate = self
    }
    
    func setData() {      
        labelDistance.textColor = .colorApp

        labelRestaurantName.text = restuarentResponseModel?.name
        let completeAddress = "\(restuarentResponseModel?.address ?? ""), \(restuarentResponseModel?.city ?? ""), \(restuarentResponseModel?.state ?? "")"

        labelRestaurantAddress.text = completeAddress
        
        labelRating.text = getRating(averageRating: restuarentResponseModel?.averageRating)
        
        labelReuse.text = getRatingEnum(averageRating: restuarentResponseModel?.willReturnPercentage) + "%"
        stackViewReturning.isHidden = getRatingEnum(averageRating: restuarentResponseModel?.willReturnPercentage) == "0"
        
        labelComments.text = "\(restuarentResponseModel?.totalReviews ?? 0)"
        stackViewComments.isHidden = (restuarentResponseModel?.totalReviews ?? 0) == 0
        
        labelPictures.text = "\(restuarentResponseModel?.totalPhotos ?? 0)"
        stackViewPhotos.isHidden = (restuarentResponseModel?.totalPhotos ?? 0) == 0
        
        
        labelDistance.text = "\(oneDecimalDistance(distance:restuarentResponseModel?.distance))"
        //        labelDistance.text = "\(oneDecimalDistance(distance:modelFeaturedRestuarantResponseData?.distance))\(modelFeaturedRestuarantResponseData?.distance?.readableUnit ?? "")"
        imageViewRestaurant.setImage(urlString: restuarentResponseModel?.iconImageWebUrl ?? "", placeHolderIcon: "placeHolderRestaurant")
        imageViewItem.setImage(urlString: restuarentResponseModel?.coverImageWebUrl ?? "", placeHolderIcon: "placeHolderFoodItem")
        imageViewFavourite.image = UIImage(named: restuarentResponseModel?.isMyFavorite ?? false ? "heartFavourite" : "heartUnFavourite")
        viewCallMainBackGround.isHidden = restuarentResponseModel?.phone ?? "" == ""
//        stackViewFavouriteBackGround.isHidden = !(restuarentResponseModel?.isMyFavorite ?? false)
        
        if let cuisines = restuarentResponseModel?.cuisines {
            let filteredCuisines = cuisines.compactMap { $0?.name }.filter { !$0.isEmpty }
            arrayNames = filteredCuisines
            collectionView.reloadData()
        }
        viewBackGroundDelivery.isHidden = !(restuarentResponseModel?.offersDelivery ?? false)
        
        let isNewRestaurent = ifNewRestaurent(createdOn: restuarentResponseModel?.createdOn ?? "")
        viewItemTypeBackGround.isHidden = isNewRestaurent == ""
        labelItemType.text = isNewRestaurent
        viewItemTypeBackGround.backgroundColor = .colorGreen
        
        
        let isClose = !isRestaurantOpen(timings: restuarentResponseModel?.timings ?? []).0
        if isClose {
            //                viewItemTypeBackGround.isHidden = !isClose
            //                labelItemType.text = "Close"
            //                viewItemTypeBackGround.backgroundColor = .colorRed
        }
        //            viewItemTypeBackGround.backgroundColor = .colorOrange
        viewBackGroundDelivery.isHidden = true
    }
    
    func favouriteRestaurants() {
        let parameters = [
            "placeId": restuarentResponseModel?.id ?? ""
        ]
        
        APIs.getAPI(apiName: restuarentResponseModel?.isMyFavorite ?? false == true ? .favouriteDelete : .favourite, parameters: parameters, isPathParameters: true, methodType: restuarentResponseModel?.isMyFavorite ?? false == true ? .delete : .post, viewController: viewController) { responseData, success, errorMsg, statusCode in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostFavouriteRestaurantsResponse = model
            }
        }
    }
    
    struct ModelPostFavouriteDeleteResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
    }
}

extension FindHalalFoodCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 20
        return CGSize(width: width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodItemSubCuisineCell", for: indexPath) as! HomeFoodItemSubCuisineCell
        cell.labelName.text = arrayNames[indexPath.item]

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
//        collectionView.reloadData()
    }
}

extension FindHalalFoodCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 170, height: 135))
        let infoView = Bundle.loadView(fromNib: "MarkerInfoView", withType: MarkerInfoView.self)
        view.addSubview(infoView)
        if let modelData = marker.userData as? HomeViewController.ModelRestuarantResponseData {
            infoView.marker = marker
            infoView.modelRestuarantResponseData = modelData
        }
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("when click on info View")
        if let userData = marker.userData as? HomeViewController.ModelRestuarantResponseData {
            self.viewController.dialNumber(isMapDirection: true, isPrayerPlaces: false, name: userData.name ?? "", number: userData.phone ?? "", isActionSheet: true) { [self] actionType in
                if let modelData = marker.userData as? HomeViewController.ModelRestuarantResponseData {
                    navigateToDeliveryDetailsViewController(indexPath: indexPath, actionType: actionType ?? "viewdetails", dataModel: modelData)
                }
            }
        }
    }
    
    func navigateToDeliveryDetailsViewController(indexPath: IndexPath, actionType: String, dataModel: HomeViewController.ModelRestuarantResponseData) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
        vc.delegate = viewController as? any DeliveryDetailsViewController3Delegate
        vc.indexPath = indexPath
        vc.selectedMenuCell = (viewController as? HomeViewController)?.selectedMenuCell
        vc.userLocation = (viewController as? HomeViewController)?.userLocation
        
        var modelData = dataModel
        if let halalRestuarantResponseData = restuarentResponseModel {
            
//            vc.modelRestuarantResponseData = halalRestuarantResponseData
//            modelData = halalRestuarantResponseData
        }
        
        if actionType == "viewdetails" {
            vc.modelRestuarantResponseData = dataModel
            viewController.navigationController?.pushViewController(vc, animated: true)

        }
        else if actionType == "mapdirection" {
            let completeAddress = "\(modelData.name ?? "") \(modelData.address ?? "") \(modelData.city ?? "") \(modelData.state ?? "") \(modelData.country ?? "")"
            OpenMapDirections.present(in: viewController, sourceView: buttonCall, latitude: modelData.latitude ?? 0, longitude: modelData.longitude ?? 0, locationAddress: completeAddress)
        }
    }
    
    @objc func tapOnMapInfoView() {
        print("tapOnMapInfoView")
        print("when click on info View")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.icon = UIImage(named: "markerHomeSelected")
        return false // return false to display info window
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "markerHome")
    }
}

extension Bundle {
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
//        Bundle.main.loadNibNamed("MarkerInfoView", owner: nil, options: nil)?.first as? MarkerInfoView
        fatalError("Could not load view with type " + String(describing: type))
    }
}

