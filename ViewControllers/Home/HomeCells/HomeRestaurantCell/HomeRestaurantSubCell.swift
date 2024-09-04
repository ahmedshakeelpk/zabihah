//
//  HomeRestaurantSubCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

protocol HomeRestaurantSubCellDelegate: AnyObject {
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UICollectionViewCell)
}

class HomeRestaurantSubCell: UICollectionViewCell {
    @IBOutlet weak var viewCallMainBackGround: UIView!
    @IBOutlet weak var viewBackGroundDelivery: UIView!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
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
    @IBOutlet weak var buttonOpenDirectionMap: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var buttonCall: UIButton!

    var delegate: HomeRestaurantSubCellDelegate!
    var buttonFavouriteHandler: (() -> ())!
    var viewController = UIViewController()
    var indexPath: IndexPath! = nil
    var arrayNames = [String]()
//    var isFavourite = false
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            print(modelPostFavouriteRestaurantsResponse as Any)
            if modelPostFavouriteRestaurantsResponse?.success ?? false {
//                if let isFavourite = self.modelFeaturedRestuarantResponseData?.isFavorites {
//                    delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: indexPath, cellType: HomeRestaurantSubCell())
////                    modelFeaturedRestuarantResponseData.isFavorites = !(isFavourite)
//                }
            }
            else {
                viewController.showAlertCustomPopup(title: "Error!", message: modelPostFavouriteRestaurantsResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    var restuarentResponseModel: HomeViewController.ModelRestuarantResponseData! {
        didSet {
            setData()
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
        
        HomeRestaurantSubCuisineCell.register(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imageViewRestaurant.circle()
        setData()
    }
    @IBAction func buttonOpenDirectionMap(_ sender: Any) {
        OpenMapDirections.present(in: viewController, sourceView: buttonOpenDirectionMap, latitude: restuarentResponseModel?.latitude ?? 0, longitude: restuarentResponseModel?.longitude ?? 0, locationName: restuarentResponseModel?.address ?? "")
    }
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any HomeRestaurantSubCellDelegate
        postFavouriteRestaurants()
    }
    @IBAction func buttonCall(_ sender: Any) {
        self.viewController.dialNumber(number: restuarentResponseModel?.phone ?? "")
    }
    
    struct ModelPostFavouriteRestaurantsResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
    }

    
    func setData() {
        labelRestaurantName.text = restuarentResponseModel?.name
        labelRestaurantAddress.text = restuarentResponseModel?.address
        labelRating.text = getRating(averageRating: restuarentResponseModel?.averageRating)
        labelReuse.text = getRating(averageRating: restuarentResponseModel?.willReturnPercentage)
        labelComments.text = "\(restuarentResponseModel?.totalReviews ?? 0)"
        labelPictures.text = "\(restuarentResponseModel?.totalPhotos ?? 0)"
        labelDistance.text = "\(oneDecimalDistance(distance:restuarentResponseModel?.distance))"
//        labelDistance.text = "\(oneDecimalDistance(distance:modelFeaturedRestuarantResponseData?.distance))\(modelFeaturedRestuarantResponseData?.distance?.unit ?? "")"
        imageViewRestaurant.setImage(urlString: restuarentResponseModel?.iconImageWebUrl ?? "", placeHolderIcon: "placeHolderRestaurant")
        imageViewItem.setImage(urlString: restuarentResponseModel?.coverImageWebUrl ?? "", placeHolderIcon: "placeHolderFoodItem")
        imageViewFavourite.image = UIImage(named: restuarentResponseModel?.isFavorites ?? false ? "heartFavourite" : "heartUnFavourite")
        viewCallMainBackGround.isHidden = restuarentResponseModel?.phone ?? "" == ""
        
        if let cuisines = restuarentResponseModel?.cuisines {
            let filteredCuisines = cuisines.compactMap { $0?.name }.filter { !$0.isEmpty }
            arrayNames = filteredCuisines
            collectionView.reloadData()
        }
        viewBackGroundDelivery.isHidden = !(restuarentResponseModel?.offersDelivery ?? false)
        viewItemTypeBackGround.isHidden = restuarentResponseModel?.restaurantType == ""
        labelItemType.text = restuarentResponseModel?.restaurantType
        if restuarentResponseModel?.meatHalalStatus?.lowercased() == "close" {
            viewItemTypeBackGround.backgroundColor = .colorRed
        }
        else if restuarentResponseModel?.meatHalalStatus?.lowercased() == "new" || restuarentResponseModel?.meatHalalStatus?.lowercased() == "open"{
            viewItemTypeBackGround.backgroundColor = .colorGreen
        }
        else if restuarentResponseModel?.meatHalalStatus?.lowercased() != "" {
            viewItemTypeBackGround.backgroundColor = .colorOrange
        }
    }
    
    func postFavouriteRestaurants() {
//        let parameters = [
//            "Id": modelFeaturedRestuarantResponseData?.id ?? "",
//            "isMark": !(modelFeaturedRestuarantResponseData?.isFavorites ?? false),
//            "type" : "rest"
//        ] as [String : Any]
//       
//        APIs.postAPI(apiName: .postfavouriterestaurants, parameters: parameters, viewController: viewController) { responseData, success, errorMsg, statusCode in
//            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelPostFavouriteRestaurantsResponse = model
//        }
    }
}

extension HomeRestaurantSubCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRestaurantSubCuisineCell", for: indexPath) as! HomeRestaurantSubCuisineCell
        cell.labelName.text = arrayNames[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
}
