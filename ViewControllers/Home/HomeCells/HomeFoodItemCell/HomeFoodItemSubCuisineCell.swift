//
//  HomeFoodItemSubCuisineCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 10/07/2024.
//

import UIKit

class HomeFoodItemSubCuisineCell: UICollectionViewCell {

    @IBOutlet weak var viewBackGroundName: UIView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBackGroundName.radius(color: .clrGreen2nd, borderWidth: 2)
        self.viewBackGroundName.backgroundColor = .clrLightGreen
        DispatchQueue.main.async {
            self.viewBackGroundName.circle()
            
        }
    }

}
