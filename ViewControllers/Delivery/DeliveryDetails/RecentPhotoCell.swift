//
//  RecentPhotoCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 29/07/2024.
//

import UIKit

class RecentPhotoCell: UICollectionViewCell {

    @IBOutlet weak var viewCancelButtonMainBackGround: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var viewCancelButtonBackGround: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    var removeImageHandler: ((IndexPath) -> ())!
    var indexPath: IndexPath!
    var isCancelButtonShow: Bool = false {
        didSet {
            viewCancelButtonMainBackGround.isHidden = !isCancelButtonShow
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 8)
        viewCancelButtonBackGround.circle()
        isCancelButtonShow = false
    }

    @IBAction func buttonCancel(_ sender: Any) {
        removeImageHandler?(indexPath)
    }
}
