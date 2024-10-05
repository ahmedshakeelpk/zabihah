//
//  HomeBaseCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit


class HomeBaseCell: UITableViewCell {
    var viewController = UIViewController()
    var data : Any!
//    var type : HomeListItem!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func setupWithType(type : HomeListItem){
//        self.type = type
//    }
  
    func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        self.viewController = viewController
        self.indexPath = indexPath
        self.data = data
    }
}

extension HomeBaseCell {
    struct HomeListItem {
        var identifier : String
        var sectionName : String?
        var rowHeight : Int?
        var data : Any?
    }
}


