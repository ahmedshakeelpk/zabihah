//
//  HomeMenuCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

class HomeMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var viewImageViewTitleBackGround: UIView!
    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewImageViewTitleBackGround.radius(radius: 8)
    }

}
