//
//  MyFavouriteCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class MyFavouriteCell: UITableViewCell {
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    
    var index: Int!
    var buttonDeleteHandler: ((Int) -> ())!
    var buttonCheckHandler: ((Int) -> ())!
    
    var selectedAddressIndex: Int? {
        didSet {
            
        }
    }
    var halalRestuarantResponseData: HomeViewController.ModelRestuarantResponseData? {
        didSet {
            if halalRestuarantResponseData != nil {
                labelTitle.text = halalRestuarantResponseData?.name ?? ""
                labelAddress.text = halalRestuarantResponseData?.address ?? ""
                
                imageViewRestaurant.setImage(urlString: halalRestuarantResponseData?.iconImage ?? "", placeHolderIcon: "placeHolderRestaurant")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackGroundForRadius.setShadow()
        stackViewBackGround.radius(radius: 12)
        imageViewRestaurant.circle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonDelete(_ sender: UIButton) {
        buttonDeleteHandler?(index)
    }
    @IBAction func buttonCheck(_ sender: Any) {
        buttonCheckHandler?(index)
    }
    
}
