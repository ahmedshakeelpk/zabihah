//
//  MarkerInfoView.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/08/2024.
//

import UIKit
import GoogleMaps


class MarkerInfoView: UIView {

    @IBOutlet weak var stackViewPhotosBackGround: UIStackView!
    @IBOutlet weak var viewCallMainBackGround: UIView!
    @IBOutlet weak var buttonTapOnView: UIButton!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRestaurantAddress: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var viewRestaurantBackGround: UIView!

    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelImages: UILabel!
    
    var marker: GMSMarker!
    var buttonTapOnViewHandler: (() -> ())!
    var isPrayerPlace: Bool? = false
    
    var modelRestuarantResponseData: HomeViewController.ModelRestuarantResponseData? {
        didSet {
            setModelRestuarantResponseData()
        }
    }
    
    func setModelRestuarantResponseData() {
        labelDistance.textColor = .colorApp

        viewRestaurantBackGround.isHidden = false
        labelRestaurantName.text = modelRestuarantResponseData?.name
        labelRestaurantAddress.text = modelRestuarantResponseData?.address
        labelRating.text = getRating(averageRating: modelRestuarantResponseData?.averageRating)
        labelImages.text = "\(modelRestuarantResponseData?.totalPhotos ?? 0)"
        stackViewPhotosBackGround.isHidden = !(modelRestuarantResponseData?.totalPhotos ?? 0 > 0)
        labelDistance.text = "\(oneDecimalDistance(distance:modelRestuarantResponseData?.distance))"
        viewCallMainBackGround.isHidden = modelRestuarantResponseData?.phone ?? "" == ""
        self.marker?.userData = modelRestuarantResponseData
        imageViewItem.setImage(urlString: modelRestuarantResponseData?.iconImageWebUrl ?? "", placeHolderIcon: isPrayerPlace ?? false ? "placeHolderPrayerPlaces" : "placeHolderFoodItem") {_ in
            
            self.marker?.tracksInfoWindowChanges = true
        }
        imageViewRestaurant.setImage(urlString: modelRestuarantResponseData?.coverImageWebUrl ?? "", placeHolderIcon: "placeHolderRestaurant") {_ in
            self.marker?.tracksInfoWindowChanges = true
        }
        viewRestaurantBackGround.isHidden = isPrayerPlace ?? false
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
