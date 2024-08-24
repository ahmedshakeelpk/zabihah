//
//  RecentPhotoCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 29/07/2024.
//

import UIKit

class RecentPhotoCell: UICollectionViewCell {

    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 8)
    }

}
