//
//  HomePrayerSpacesSubCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

extension HomePrayerSpacesSubCell {
    struct ModelPostFavouriteRestaurantsResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
    }
}

protocol HomePrayerSpacesSubCellDelegate: AnyObject {
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UICollectionViewCell)
}

class HomePrayerSpacesSubCell: UICollectionViewCell {
    @IBOutlet weak var stackViewReturning: UIStackView!
    @IBOutlet weak var stackViewComments: UIStackView!
    @IBOutlet weak var stackViewPhotos: UIStackView!

    
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonOpenDirectionMap: UIButton!
    @IBOutlet weak var stackViewFavouriteBackGround: UIStackView!

    @IBOutlet weak var stackViewRatingBackGround: UIStackView!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var viewBackGroundNewRestaurant: UIView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRestaurantAddress: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelReuse: UILabel!
    @IBOutlet weak var labelPictures: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var viewBackGroundDelivery: UIView!
    @IBOutlet weak var viewItemTypeBackGround: UIView!
    @IBOutlet weak var labelItemType: UILabel!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewBikeBackGround: UIView!
    @IBOutlet weak var viewCallBackGround: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var viewCallMainBackGround: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    
    
    
    var delegate: HomeFoodItemSubCellDelegate!
    var buttonFavouriteHandler: (() -> ())!
    var viewController = UIViewController()
    var indexPath: IndexPath! = nil
    var arrayNames = [String]()

    var restuarentResponseModel: HomeViewController.ModelRestuarantResponseData! {
        didSet {
            DispatchQueue.main.async {
                self.setData()
            }
        }
    }
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            if let isFavourite = self.restuarentResponseModel?.isMyFavorite {
                DispatchQueue.main.async {
                    self.delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: self.indexPath, cellType: HomePrayerSpacesSubCell())
                }
                restuarentResponseModel.isMyFavorite = !(isFavourite)
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
        
        HomeFoodItemSubCuisineCell.register(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func buttonOpenDirectionMap(_ sender: Any) {
        OpenMapDirections.present(in: viewController, sourceView: buttonOpenDirectionMap, latitude: restuarentResponseModel?.latitude ?? 0, longitude: restuarentResponseModel?.longitude ?? 0, locationName: restuarentResponseModel?.address ?? "")
    }
    @IBAction func buttonCall(_ sender: Any) {
        self.viewController.dialNumber(number: restuarentResponseModel?.phone ?? "")
    }
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any HomeFoodItemSubCellDelegate
        favouriteRestaurants()
    }
    
    func setData() {
        labelRestaurantName.text = restuarentResponseModel?.name
        labelRestaurantAddress.text = restuarentResponseModel?.address
        labelRating.text = getRating(averageRating: restuarentResponseModel?.averageRating)
        
        labelReuse.text = getRatingEnum(averageRating: restuarentResponseModel?.willReturnPercentage) + "%"
        stackViewReturning.isHidden = getRatingEnum(averageRating: restuarentResponseModel?.willReturnPercentage) == "0"
        
        labelComments.text = "\(restuarentResponseModel?.totalReviews ?? 0)"
        stackViewComments.isHidden = (restuarentResponseModel?.totalPhotos ?? 0) == 0
        
        labelPictures.text = "\(restuarentResponseModel?.totalPhotos ?? 0)"
        stackViewPhotos.isHidden = (restuarentResponseModel?.totalPhotos ?? 0) == 0
        
        
        
        labelDistance.text = "\(oneDecimalDistance(distance:restuarentResponseModel?.distance))"
        //        labelDistance.text = "\(oneDecimalDistance(distance:modelFeaturedRestuarantResponseData?.distance))\(modelFeaturedRestuarantResponseData?.distance?.unit ?? "")"
        imageViewRestaurant.setImage(urlString: restuarentResponseModel?.iconImageWebUrl ?? "", placeHolderIcon: "placeHolderRestaurant")
        imageViewItem.setImage(urlString: restuarentResponseModel?.coverImageWebUrl ?? "", placeHolderIcon: "placeHolderPrayerPlaces")
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
        
    }
    
    func favouriteRestaurants() {
        let parameters = [
            "placeId": restuarentResponseModel.id ?? ""
        ]
        
        APIs.getAPI(apiName: restuarentResponseModel?.isMyFavorite ?? false == true ? .favouriteDelete : .favourite, parameters: parameters, isPathParameters: true, methodType: restuarentResponseModel?.isMyFavorite ?? false == true ? .delete : .post, viewController: viewController) { responseData, success, errorMsg, statusCode in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostFavouriteRestaurantsResponse = model
            }
        }
    }
}

extension HomePrayerSpacesSubCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        collectionView.reloadData()
    }
}
