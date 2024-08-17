//
//  DeliveryTimingCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 17/08/2024.
//

import UIKit

class DeliveryTimingCell: UITableViewCell {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTiming: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
