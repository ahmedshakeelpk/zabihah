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
    @IBOutlet weak var imageViewPlaceHolder: UIImageView!
    @IBOutlet weak var viewBottomLine: UIView!
    var selectedPlaceHolderIcon: String!
    var modelCuisine: HomeViewController.ModelCuisine? {
        didSet {
            labelName.text = modelCuisine?.name
            imageViewTitle.setImage(urlString: modelCuisine?.iconImageWebUrl ?? "", placeHolderIcon: selectedPlaceHolderIcon) {
                image in
//                if image == nil {
//                    self.imageViewTitle.isHidden = true
//                    self.imageViewPlaceHolder.image = UIImage(named: self.selectedPlaceHolderIcon)
//                }
//                else {
//                    self.imageViewTitle.isHidden = false
//                    self.imageViewPlaceHolder.isHidden = true
//                }
            }
        }
    }
    var selectedCuisine: String? = "" {
        didSet {
            if selectedCuisine == modelCuisine?.name {
                labelName.textColor = .colorApp
                viewBottomLine.backgroundColor = .colorApp
//                viewImageViewTitleBackGround.radius(radius: 8, color: .colorApp, borderWidth: 2)
            }
            else {
                labelName.textColor = .colorLabel
                viewBottomLine.backgroundColor = .clear
//                viewImageViewTitleBackGround.radius(radius: 8, color: .white, borderWidth: 2)
            }
            viewImageViewTitleBackGround.radius(radius: 8, color: .white, borderWidth: 2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewImageViewTitleBackGround.radius(radius: 12, color: .white, borderWidth: 2)
    }
}
