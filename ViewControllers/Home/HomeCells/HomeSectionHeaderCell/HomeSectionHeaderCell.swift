//
//  SideMenuViewHeaderFooterViewCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class HomeSectionHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var viewButtonViewAllBackGround: UIView!
    
    @IBOutlet weak var buttonViewAll: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelViewAll: UILabel!
    
    var viewController: UIViewController!
    var selectedMenuCell: Int!
    var section: Int!
    var buttonViewAllHandler: ((_ section: Int) -> ())!
    var cuisineCount: String? {
        didSet {
            DispatchQueue.main.async {
                self.cuisineCount = ""
            }
        }
    }
    var sectionName: String? {
        didSet {
            DispatchQueue.main.async {
                self.labelTitle.isHidden = true
                self.viewButtonViewAllBackGround.isHidden = true
                (self.viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = Int(self.cuisineCount ?? "0") == 0
                
                if self.selectedMenuCell == 0 {
                    if self.section == 0 {
                        //Hide
                        self.viewButtonViewAllBackGround.isHidden = true
                        if self.sectionName != "" {
                            self.labelTitle.text = "\(self.sectionName ?? "")     "
                            self.labelTitle.isHidden = false
                        }
                    }
                    else if self.section == 1 {
                        //Show
                        if self.sectionName != "" {
                            self.viewButtonViewAllBackGround.isHidden = false
                            self.labelTitle.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            self.labelTitle.isHidden = false
                            (self.viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            (self.viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                        }
                    }
                    else if self.section == 2 {
                        //Hide
                        self.viewButtonViewAllBackGround.isHidden = true
                    }
                    else if self.section == 3 {
                        //Show
                        if self.sectionName != "" {
                            self.viewButtonViewAllBackGround.isHidden = false
                            self.labelTitle.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            self.labelTitle.isHidden = false
                            (self.viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            (self.viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                        }
                    }
                    else {
                        self.viewButtonViewAllBackGround.isHidden = true
                    }
                }
                else if self.selectedMenuCell == 1 {
                    if self.section == 0 {
                        if self.sectionName != "" {
                            self.labelTitle.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            self.labelTitle.isHidden = false
                            (self.viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            (self.viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                        }
                    }
                    else {
                        
                    }
                }
                else if self.selectedMenuCell == 3 {
                    if self.section == 0 {
                        if self.sectionName != "" {
                            self.labelTitle.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            self.labelTitle.isHidden = false
                            (self.viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(self.cuisineCount ?? "") \(self.sectionName ?? "")     "
                            (self.viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                            (self.viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                        }
                    }
                }

            }
        }
    }
    
    var modelGetHomeRestaurantsResponse: HomeViewController.ModelFeaturedResponse? {
        didSet {
            
        }
    }
    var modelGetHalalRestaurantResponse: HomeViewController.ModelFeaturedResponse? {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelViewAll.underline()
        
        labelViewAll.textColor = .colorApp
    }
    @IBAction func buttonViewAll(_ sender: Any) {
        print(section)
        buttonViewAllHandler(section)
    }
    
}
