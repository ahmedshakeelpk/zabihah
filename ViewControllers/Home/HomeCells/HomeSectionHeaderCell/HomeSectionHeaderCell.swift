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
    @IBOutlet weak var labelViewAll: UILabel!
    
    var section: Int!
    var buttonViewAllHandler: ((_ section: Int) -> ())!
    
    var sectionName: String? {
        didSet {
            if sectionName?.lowercased() == "" {
                labelViewAll.text = ""
                buttonViewAll.isEnabled = false
            }
            else if sectionName?.lowercased() == "Featured Near You".lowercased() {
                labelViewAll.text = ""
                buttonViewAll.isEnabled = false
            }
            else {
                labelViewAll.text = "View All"
                buttonViewAll.isEnabled = true
            }
            if section == 1 {
                
                labelTitle.text = "\(modelGetHomeRestaurantsResponse?.cuisine?.count ?? 0)\(sectionName ?? "")"
            }
            else {
                labelTitle.text = sectionName
            }
        }
    }
    
    var modelGetHomeRestaurantsResponse: HomeViewController.ModelGetHomeRestaurantsResponse? {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonViewAll(_ sender: Any) {
        print(section)
        buttonViewAllHandler(section)
    }
    
}
