//
//  HomeBaseCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit


class HomeBaseCell: UITableViewCell {
    var viewController = UIViewController()
    var type : HomeListItem!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWithType(type : HomeListItem){
        self.type = type
    }
}

extension HomeBaseCell {
    struct HomeListItem {
        let identifier : String
        let sectionName : String
        let rowHeight : Int
        var data : Any
    }
}


