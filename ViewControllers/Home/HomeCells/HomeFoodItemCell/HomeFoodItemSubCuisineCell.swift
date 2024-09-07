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
        self.viewBackGroundName.radius(color: .colorRed2, borderWidth: 1)
        self.viewBackGroundName.backgroundColor = .clrLightRed2
        DispatchQueue.main.async {
            self.viewBackGroundName.circle()
            
        }
    }

}
