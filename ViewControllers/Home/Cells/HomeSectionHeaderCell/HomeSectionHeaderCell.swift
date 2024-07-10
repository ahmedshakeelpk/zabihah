//
//  SideMenuViewHeaderFooterViewCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class HomeSectionHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var buttonViewAll: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    var section: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonViewAll(_ sender: Any) {
        print(section)
    }
    
}
