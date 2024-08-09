//
//  HomeCuisinesCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

class HomeCuisinesSubCell: UICollectionViewCell {

    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var viewImageViewTitleBackGround: UIView!

    var modelCuisine: HomeViewController.ModelCuisine? {
        didSet {
            labelName.text = modelCuisine?.name
            imageViewTitle.setImage(urlString: modelCuisine?.image ?? "", placeHolderIcon: "placeHolderSubCuisine") {
                image in
                if image == nil {
                    self.imageViewTitle.isHidden = true
                }
            }
        }
    }
    var selectedCuisine: String? = "" {
        didSet {
            if selectedCuisine == modelCuisine?.name {
                labelName.textColor = .colorApp
                viewImageViewTitleBackGround.radius(radius: 8, color: .colorApp, borderWidth: 1)
            }
            else {
                labelName.textColor = .colorLabel
                viewImageViewTitleBackGround.radius(radius: 8, color: .white, borderWidth: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewImageViewTitleBackGround.radius(radius: 12, color: .white, borderWidth: 2)
    }
}
