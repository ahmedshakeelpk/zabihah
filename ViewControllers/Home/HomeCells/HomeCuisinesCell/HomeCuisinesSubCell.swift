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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewImageViewTitleBackGround.radius(radius: 12, color: .white, borderWidth: 2)
    }

}
