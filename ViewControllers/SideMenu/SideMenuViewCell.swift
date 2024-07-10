//
//  SideMenuViewCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit

class SideMenuViewCell: UITableViewCell {

    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var viewSeperatorLogout: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewTitle: UIImageView!
    
    var indexPath: IndexPath! {
        didSet {
            viewSeperator.isHidden = true
            viewSeperatorLogout.isHidden = true

            if indexPath.section == 0 {
                if indexPath.row == 2 {
                    viewSeperator.isHidden = false
                }
            }
            else {
                if indexPath.row == 2 {
                    viewSeperator.isHidden = false
                }
                else if indexPath.row == 3 {
                    //Using for Logout Seperator
                    viewSeperatorLogout.isHidden = false
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(indexPath: IndexPath, nameTitle: String, iconTitle: String) {
        self.indexPath = indexPath
        labelTitle.text = nameTitle
        imageViewTitle.image = UIImage(named: iconTitle)
    }
}
