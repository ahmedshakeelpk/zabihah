//
//  HomePrayerPlacesTabCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/08/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension HomePrayerPlacesTabCell {
    struct ModelPostFavouriteRestaurantsResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
    }
}

protocol HomePrayerPlacesTabCellDelegate: AnyObject {
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UITableViewCell)
}

class HomePrayerPlacesTabCell: HomeBaseCell {
    
    @IBOutlet weak var stackViewRatingBackGround: UIStackView!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var viewItemTypeBackGround: UIView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRestaurantAddress: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelReuse: UILabel!
    @IBOutlet weak var labelPictures: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelItemType: UILabel!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewCallBackGround: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var viewCallMainBackGround: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var buttonCall: UIButton!

    var delegate: HomePrayerPlacesTabCellDelegate!
    var dataRecord: HomeBaseCell.HomeListItem!

    var buttonFavouriteHandler: (() -> ())!
   
    var arrayNames = [String]()

    var modelMosqueResponseData: HomeViewController.ModelGetPrayerPlacesResponseData! {
        didSet {
            setData()
        }
    }
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            print(modelPostFavouriteRestaurantsResponse as Any)
            if modelPostFavouriteRestaurantsResponse?.success ?? false {
                if let isFavourite = self.modelMosqueResponseData?.isFavorites {
                    delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: indexPath, cellType: HomePrayerPlacesTabCell())
                    modelMosqueResponseData.isFavorites = !(isFavourite)
                }
            }
            else {
                viewController.showAlertCustomPopup(title: "Error!", message: modelPostFavouriteRestaurantsResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 12)
        viewCallBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewRatingBackGround.radius(radius: 4)
        viewItemTypeBackGround.circle()
        
        HomeFoodItemSubSuisineCell.register(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        super.updateCell(data: data, indexPath: indexPath, viewController: viewController)
        // Configure the view for the selected state
        dataRecord = data as? HomeBaseCell.HomeListItem
        if let modelData = dataRecord.data as? [HomeViewController.ModelGetPrayerPlacesResponseData] {
            modelMosqueResponseData = modelData[indexPath.row]
        }
        collectionView.reloadData()
        drawMarkerOnMap()
    }
    
    @IBAction func buttonCall(_ sender: Any) {
        self.viewController.dialNumber(number: modelMosqueResponseData?.phone ?? "")
    }
    
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any HomePrayerPlacesTabCellDelegate
        postFavouriteRestaurants()
    }
    
    func setData() {
        labelRestaurantName.text = modelMosqueResponseData?.name ?? ""
        labelRestaurantAddress.text = modelMosqueResponseData?.address ?? ""
        labelRating.text = "\(modelMosqueResponseData?.rating ?? 0)"
        labelComments.text = "\(modelMosqueResponseData?.reviews ?? 0)"
        labelPictures.text = "\(modelMosqueResponseData?.gallaryCount ?? 0)"
        labelDistance.text = "\(modelMosqueResponseData?.distance ?? 0)\(modelMosqueResponseData?.distanceUnit ?? "")"
        
        imageViewRestaurant.setImage(urlString: modelMosqueResponseData?.iconImage ?? "", placeHolderIcon: "placeHolderRestaurant")
        imageViewItem.setImage(urlString: modelMosqueResponseData?.coverImage ?? "", placeHolderIcon: "placeHolderPrayerPlaces")
        imageViewFavourite.image = UIImage(named: modelMosqueResponseData?.isFavorites ?? false ? "heartFavourite" : "heartUnFavourite")
        viewCallMainBackGround.isHidden = modelMosqueResponseData?.phone ?? "" == ""
        viewItemTypeBackGround.isHidden = modelMosqueResponseData?.status == ""
        labelItemType.text = modelMosqueResponseData?.status
        if modelMosqueResponseData?.status?.lowercased() == "closed" {
            viewItemTypeBackGround.backgroundColor = .colorRed
        }
        else if modelMosqueResponseData?.status?.lowercased() == "new" {
            viewItemTypeBackGround.backgroundColor = .colorGreen
        }
        else if modelMosqueResponseData?.status?.lowercased() != "" {
            viewItemTypeBackGround.backgroundColor = .colorOrange
        }
        if var tags = modelMosqueResponseData?.tags?.split(separator: ",").map({ String($0)}) {
            if tags.last == "" || tags.last == " "{
                tags.removeLast()
            }
            arrayNames = tags
            collectionView.reloadData()
        }
    }
    func drawMarkerOnMap() {
        /// Marker - Google Place marker
//        let marker: GMSMarker = GMSMarker() // Allocating Marker
//        marker.title = modelMosqueResponseData?.name // Setting title
//        marker.snippet = modelMosqueResponseData?.address // Setting sub title
//        marker.icon = UIImage(named: "markerPrayerPlaces") // Marker icon
//        marker.appearAnimation = .pop // Appearing animation. default
//        marker.userData = modelMosqueResponseData
        
        let location = CLLocationCoordinate2D(latitude: modelMosqueResponseData?.lat ?? 0, longitude: modelMosqueResponseData?.long ?? 0)
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
    func postFavouriteRestaurants() {
        let parameters = [
            "Id": modelMosqueResponseData?.id ?? "",
            "isMark": !(modelMosqueResponseData?.isFavorites ?? false),
            "type" : "prayer"
            
        ] as [String : Any]
       
        APIs.postAPI(apiName: .postfavouriterestaurants, parameters: parameters, viewController: viewController) { responseData, success, errorMsg in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelPostFavouriteRestaurantsResponse = model
        }
    }
}

extension HomePrayerPlacesTabCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodItemSubSuisineCell", for: indexPath) as! HomeFoodItemSubSuisineCell
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
        collectionView.reloadData()
    }
}

extension HomePrayerPlacesTabCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 170, height: 135))
        let infoView = Bundle.loadView(fromNib: "MarkerInfoView", withType: MarkerInfoView.self)
        view.addSubview(infoView)
        if let modelData = marker.userData as? HomeViewController.ModelGetPrayerPlacesResponseData {
            infoView.modelGetPrayerPlacesResponseData = modelData
        }
        marker.icon = UIImage(named: "markerPrayerPlacesSelected")
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("when click on info View")
        if let userData = marker.userData as? HomeViewController.ModelGetPrayerPlacesResponseData {
            self.viewController.dialNumber(number: userData.phone ?? "") { actionType in
                if actionType == "viewdetails" {
                    print("View Details")
                }
            }
        }
    }
    
    @objc func tapOnMapInfoView() {
        print("tapOnMapInfoView")
        print("when click on info View")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.icon = UIImage(named: "markerPrayerPlacesSelected")
        return false // return false to display info window
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "markerPrayerPlaces")
    }
}
