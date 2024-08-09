//
//  HomeMenuCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

class HomeMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var viewSelectedMenuBackGround: UIView!
    @IBOutlet weak var viewImageViewTitleBackGround: UIView!
    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    let arrayNamesIcon = ["homeGray", "chefHatHome", "bikeHome", "mosqueHome"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImageViewTitleBackGround.radius(radius: 8)
        viewSelectedMenuBackGround.circle()
    }
    
    func selectedCell(selectedMenuCell: Int, indexPath: IndexPath) {
        imageViewTitle.image = UIImage(named: arrayNamesIcon[indexPath.item])
        imageViewTitle.image = imageViewTitle.image?.withRenderingMode(.alwaysTemplate)
        imageViewTitle.image = imageViewTitle.image?.withRenderingMode(.alwaysTemplate)

        if indexPath.item == selectedMenuCell {
            viewSelectedMenuBackGround.backgroundColor = .colorApp
            imageViewTitle.tintColor = .colorApp
        }
        else {
            viewSelectedMenuBackGround.backgroundColor = .white
            imageViewTitle.tintColor = .clrUnselectedImage
        }
    }

}
