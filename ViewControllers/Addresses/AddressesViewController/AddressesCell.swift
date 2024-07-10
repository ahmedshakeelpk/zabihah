//
//  AddressesCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class AddressesCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackGroundForRadius.setShadow()
        stackViewBackGround.radius(radius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
