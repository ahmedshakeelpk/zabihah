//
//  FAQsListViewControllerCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 28/08/2024.
//

import UIKit

class FAQsListViewControllerCell: UITableViewCell {
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var imageViewDropDown: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackGroundForRadius.setShadow()
        stackViewBackGround.radius(radius: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
