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
    
    @IBOutlet weak var viewBackGroundNewRestaurant: UIView!
    @IBOutlet weak var labelRestaurantName: UILabel!
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
    @IBOutlet weak var stackViewRatingBackGround: UIStackView!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    let arrayIconNames = ["home", "chefHatHome", "Pickup & delivery", "Prayer spaces"]
    
    var dataRecord: HomeBaseCell.HomeListItem!
    var delegate: FindHalalFoodCellDelegate!
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            print(modelPostFavouriteRestaurantsResponse as Any)
            if modelPostFavouriteRestaurantsResponse?.success ?? false {
                if let isFavourite = self.halalRestuarantResponseData?.isFavorites {
                    delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: indexPath, cellType: FindHalalFoodCell())
//                    halalRestuarantResponseData?.isFavorites = !(isFavourite)
                }
            }
            else {
                viewController.showAlertCustomPopup(title: "Error!", message: modelPostFavouriteRestaurantsResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    var halalRestuarantResponseData: HomeViewController.ModelRestuarantResponseData? {
        didSet {
            DispatchQueue.main.async {
                self.labelRestaurantName.text = self.halalRestuarantResponseData?.name
                self.labelRestaurantAddress.text = self.halalRestuarantResponseData?.address
                self.labelRating.text = "\(self.halalRestuarantResponseData?.rating ?? 0)"
                self.labelComments.text = "\(self.halalRestuarantResponseData?.reviews ?? 0)"
                self.labelPictures.text = "\(self.halalRestuarantResponseData?.gallaryCount ?? 0)"
                self.labelDistance.text = "\(self.halalRestuarantResponseData?.distance ?? 0)"
                self.imageViewRestaurant.setImage(urlString: self.halalRestuarantResponseData?.iconImage ?? "", placeHolderIcon: "placeHolderRestaurant")
                self.imageViewItem.setImage(urlString: self.halalRestuarantResponseData?.coverImage ?? "", placeHolderIcon: "placeHolderFoodItem")
                self.imageViewFavourite.image = UIImage(named: self.halalRestuarantResponseData?.isFavorites ?? false ? "heartFavourite" : "heartUnFavourite")
                
                self.viewBackGroundNewRestaurant.isHidden = self.halalRestuarantResponseData?.status == ""
                self.labelItemType.text = self.halalRestuarantResponseData?.status
                if self.halalRestuarantResponseData?.status?.lowercased() == "close" {
                    self.viewBackGroundNewRestaurant.backgroundColor = .colorRed
                }
                else if self.halalRestuarantResponseData?.status?.lowercased() == "new" || self.halalRestuarantResponseData?.status?.lowercased() == "open"{
                    self.viewBackGroundNewRestaurant.backgroundColor = .colorGreen
                }
                else if self.halalRestuarantResponseData?.status?.lowercased() != "" {
                    self.viewBackGroundNewRestaurant.backgroundColor = .colorOrange
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 12)
        viewBikeBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewCallBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewRatingBackGround.radius(radius: 4)
        viewItemTypeBackGround.circle()
        
        HomeFoodItemSubSuisineCell.register(collectionView: collectionView)
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
            halalRestuarantResponseData = modelData[indexPath.row]
        }
        collectionView.reloadData()
        drawMarkerOnMap()
    }
    
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any FindHalalFoodCellDelegate
        postFavouriteRestaurants()
    }
    
    func drawMarkerOnMap() {
        /// Marker - Google Place marker
        let marker: GMSMarker = GMSMarker() // Allocating Marker
        marker.title = halalRestuarantResponseData?.name // Setting title
        marker.snippet = halalRestuarantResponseData?.address // Setting sub title
        marker.icon = UIImage(named: "markerHome") // Marker icon
        marker.appearAnimation = .pop // Appearing animation. default
        marker.userData = halalRestuarantResponseData
        
        let location = CLLocationCoordinate2D(latitude: halalRestuarantResponseData?.lat ?? 0, longitude: halalRestuarantResponseData?.long ?? 0)
        marker.position = location
        marker.map = (viewController as? HomeViewController)?.mapView // Setting marker on Mapview
        setZoom(location: location)
    }
    
    func setZoom(location: CLLocationCoordinate2D) {
        let lat = location.latitude
        let long = location.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        (viewController as? HomeViewController)?.mapView.camera = camera
//        mapView.isMyLocationEnabled = true
        (viewController as? HomeViewController)?.mapView.delegate = self
    }
    
    func postFavouriteRestaurants() {
        let parameters = [
            "Id": halalRestuarantResponseData?.id ?? "",
            "isMark": !(halalRestuarantResponseData?.isFavorites ?? false),
            "type" : "rest"
        ] as [String : Any]
       
        APIs.postAPI(apiName: .postfavouriterestaurants, parameters: parameters, viewController: viewController) { responseData, success, errorMsg in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelPostFavouriteRestaurantsResponse = model
        }
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

extension FindHalalFoodCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 170, height: 135))
        let infoView = Bundle.loadView(fromNib: "MarkerInfoView", withType: MarkerInfoView.self)
        view.addSubview(infoView)
        if let modelData = marker.userData as? HomeViewController.ModelRestuarantResponseData {
            infoView.modelFeaturedRestuarantResponseData = modelData
        }
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("when click on info View")
    }
    
    @objc func tapOnMapInfoView() {
        print("tapOnMapInfoView")
        print("when click on info View")
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


