//
//  UpLoadPhotoCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 17/08/2024.
//

import UIKit

class UpLoadPhotoCell: UICollectionViewCell {
    @IBOutlet weak var stackViewBackGround: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 8)
    }

}
