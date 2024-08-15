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
    @IBOutlet weak var buttonCall: UIButton!

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

    var modelMosqueResponseData: HomeViewController.ModelRestuarantResponseData! {
        didSet {
            setData()
        }
    }
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            print(modelPostFavouriteRestaurantsResponse as Any)
            if modelPostFavouriteRestaurantsResponse?.success ?? false {
                if let isFavourite = self.modelMosqueResponseData?.isFavorites {
                    delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: indexPath, cellType: HomePrayerSpacesSubCell())
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
        viewBikeBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewCallBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewRatingBackGround.radius(radius: 4)
        viewItemTypeBackGround.circle()
        
        HomeFoodItemSubSuisineCell.register(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func buttonCall(_ sender: Any) {
        self.viewController.dialNumber(number: modelMosqueResponseData?.phone ?? "")
    }
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any HomeFoodItemSubCellDelegate
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
        viewBackGroundNewRestaurant.isHidden = modelMosqueResponseData?.status == ""
        labelItemType.text = modelMosqueResponseData?.status
        if modelMosqueResponseData?.status?.lowercased() == "closed" {
            viewBackGroundNewRestaurant.backgroundColor = .colorRed
        }
        else if modelMosqueResponseData?.status?.lowercased() == "new" {
            viewBackGroundNewRestaurant.backgroundColor = .colorGreen
        }
        else if modelMosqueResponseData?.status?.lowercased() != "" {
            viewBackGroundNewRestaurant.backgroundColor = .colorOrange
        }
        if var tags = modelMosqueResponseData?.tags?.split(separator: ",").map({ String($0)}) {
            if tags.last == "" || tags.last == " "{
                tags.removeLast()
            }
            arrayNames = tags
            collectionView.reloadData()
        }
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
