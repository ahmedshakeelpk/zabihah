//
//  MarkerInfoView.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/08/2024.
//

import UIKit

class MarkerInfoView: UIView {

    @IBOutlet weak var buttonTapOnView: UIButton!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRestaurantAddress: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelImages: UILabel!
    
    var buttonTapOnViewHandler: (() -> ())!
    
    var modelFeaturedRestuarantResponseData: HomeViewController.ModelRestuarantResponseData? {
        didSet {
            labelRestaurantName.text = modelFeaturedRestuarantResponseData?.name
            labelRestaurantAddress.text = modelFeaturedRestuarantResponseData?.address
            labelRating.text = "\(modelFeaturedRestuarantResponseData?.rating ?? 0)"
            labelImages.text = "\(modelFeaturedRestuarantResponseData?.gallaryCount ?? 0)"
            labelDistance.text = "\(modelFeaturedRestuarantResponseData?.distance ?? 0)\(modelFeaturedRestuarantResponseData?.distanceUnit ?? "")"
            
            
            if let iconImage = modelFeaturedRestuarantResponseData?.iconImage {
                if iconImage == "" {
                    imageViewItem.image = UIImage(named: "placeHolderRestaurant")
                }
                else {
                    imageViewRestaurant.setImage(urlString: modelFeaturedRestuarantResponseData?.iconImage ?? "", placeHolderIcon: "placeHolderRestaurant") {
                        image in
                        self.imageViewItem.image = UIImage(named: "placeHolderRestaurant")
                    }
                }
            }
            if let coverImage = modelFeaturedRestuarantResponseData?.coverImage {
                if coverImage == "" {
                    imageViewItem.image = UIImage(named: "placeHolderFoodItem")
                }
                else {
                    imageViewItem.setImage(urlString: modelFeaturedRestuarantResponseData?.coverImage ?? "", placeHolderIcon: "placeHolderFoodItem") {
                        image in
                        self.imageViewItem.image = UIImage(named: "placeHolderFoodItem")
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewRestaurant.circle()
        imageViewItem.radius(radius: 4)
        viewRatingBackGround.radius(radius: 4)
        
    }
    @IBAction func buttonTapOnView(_ sender: Any) {
        buttonTapOnViewHandler?()
    }
    
}
