//
//  DeliveryAmenitiesCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 17/08/2024.
//

import UIKit

class DeliveryAmenitiesCell: UITableViewCell {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
