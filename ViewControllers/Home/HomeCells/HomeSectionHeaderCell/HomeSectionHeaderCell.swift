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
    
    var selectedMenuCell: Int!
    var section: Int!
    var buttonViewAllHandler: ((_ section: Int) -> ())!
    
    var sectionName: String? {
        didSet {
            labelTitle.text = sectionName
            if sectionName?.lowercased() == "" {
                labelViewAll.text = ""
                buttonViewAll.isEnabled = false
            }
            else if sectionName?.lowercased() == "Featured Near You".lowercased() || section == 3 {
                labelViewAll.text = ""
                buttonViewAll.isEnabled = false
            }
            else {
                labelViewAll.text = "View All"
                buttonViewAll.isEnabled = true
                if selectedMenuCell == 1 {
                    labelViewAll.text = ""
                    labelTitle.text = "\(modelGetHalalRestaurantResponse?.cuisine?.count ?? 0)\(sectionName ?? "")"
                }
                else {
                    if section == 1 {
                        labelTitle.text = "\(modelGetHomeRestaurantsResponse?.cuisine?.count ?? 0)\(sectionName ?? "")"
                    }
                }
            }
        }
    }
    
    var modelGetHomeRestaurantsResponse: HomeViewController.ModelGetHomeRestaurantsResponse? {
        didSet {
            
        }
    }
    var modelGetHalalRestaurantResponse: HomeViewController.ModelGetHalalRestaurantResponse? {
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
