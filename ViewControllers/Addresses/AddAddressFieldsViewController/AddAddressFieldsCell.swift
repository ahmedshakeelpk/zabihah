//
//  AddAddressFieldsCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import UIKit

class AddAddressFieldsCell: UICollectionViewCell {

    @IBOutlet weak var viewImageViewTitleBackGround: UIView!
    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewImageViewTitleBackGround.radius(radius: 8)
    }

}
