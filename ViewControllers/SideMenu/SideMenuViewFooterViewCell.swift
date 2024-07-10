//
//  SideMenuViewFooterViewCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class SideMenuViewFooterViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var buttonAbout: UIButton!
    @IBOutlet weak var buttonPrivacyPolicy: UIButton!
    
    @IBOutlet weak var buttonFrequentlyAskedQuestion: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonPrivacyPolicy(_ sender: Any) {
    }
    @IBAction func buttonAbout(_ sender: Any) {
    }
    @IBAction func buttonFrequentlyAskedQuestion(_ sender: Any) {
    }
    
    
}
