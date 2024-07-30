//
//  HomeFoodItemCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

class HomeFoodItemSubCell: UICollectionViewCell {
    
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
    
    var indexPath: IndexPath! = nil
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    
    var modelFeaturedRestuarantResponseData: HomeViewController.ModelGetFeaturedRestaurantsResponseData? {
        didSet {
            labelRestaurantName.text = modelFeaturedRestuarantResponseData?.name
            labelRestaurantAddress.text = modelFeaturedRestuarantResponseData?.address
            labelRating.text = "\(modelFeaturedRestuarantResponseData?.rating ?? 0)"
            labelComments.text = "\(modelFeaturedRestuarantResponseData?.reviews ?? 0)"
            labelPictures.text = "\(modelFeaturedRestuarantResponseData?.gallaryCount ?? 0)"
            labelDistance.text = "\(modelFeaturedRestuarantResponseData?.distance ?? 0)"
            imageViewRestaurant.setImage(urlString: modelFeaturedRestuarantResponseData?.iconImage ?? "", placeHolderIcon: "placeHolderFoodItem")
            imageViewItem.setImage(urlString: modelFeaturedRestuarantResponseData?.coverImage ?? "", placeHolderIcon: "placeHolderRestaurant")
            viewBackGroundNewRestaurant.backgroundColor = (modelFeaturedRestuarantResponseData?.isClosed ?? false) ? .clrRed : .clrGreen
            if !(modelFeaturedRestuarantResponseData?.isClosed ?? false) {
                viewBackGroundNewRestaurant.isHidden = modelFeaturedRestuarantResponseData?.isNew ?? false
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

}

extension HomeFoodItemSubCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
