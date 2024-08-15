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
            
        }
    }
    var sectionName: String? {
        didSet {
            labelTitle.isHidden = true
            viewButtonViewAllBackGround.isHidden = true
            (viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = Int(cuisineCount ?? "0") == 0
            
            if selectedMenuCell == 0 {
                if section == 0 {
                    //Hide
                    viewButtonViewAllBackGround.isHidden = true
                    if sectionName != "" {
                        labelTitle.text = "\(sectionName ?? "")"
                        labelTitle.isHidden = false
                    }
                }
                else if section == 1 {
                    //Show
                    if sectionName != "" {
                        viewButtonViewAllBackGround.isHidden = false
                        labelTitle.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        labelTitle.isHidden = false
                        (viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        (viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                    }
                }
                else if section == 2 {
                    //Hide
                    viewButtonViewAllBackGround.isHidden = true
                }
                else if section == 3 {
                    //Show
                    if sectionName != "" {
                        viewButtonViewAllBackGround.isHidden = false
                        labelTitle.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        labelTitle.isHidden = false
                        (viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        (viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                    }
                }
                else {
                    viewButtonViewAllBackGround.isHidden = true
                }
            }
            else if selectedMenuCell == 1 {
                if section == 0 {
                    if sectionName != "" {
                        labelTitle.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        labelTitle.isHidden = false
                        (viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        (viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                    }
                }
                else {
                    
                }
            }
            else if selectedMenuCell == 3 {
                if section == 0 {
                    if sectionName != "" {
                        labelTitle.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        labelTitle.isHidden = false
                        (viewController as? HomeViewController)?.labelItemCountOnMapView.text = "\(cuisineCount ?? "") \(sectionName ?? "")"
                        (viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
                        (viewController as? HomeViewController)?.viewItemCountOnMapViewBackGround.isHidden = false
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
