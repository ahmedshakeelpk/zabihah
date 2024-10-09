//
//  SideMenuViewFooterViewCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class SideMenuViewFooterViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var buttonAbout: UIButton!
    @IBOutlet weak var buttonPrivacyPolicy: UIButton!
    
    var buttonAboutHandler: ( () -> ())!
    var buttonPrivacyPolicyHandler: ( () -> ())!
    var buttonFrequentlyAskQuestionHandler: ( () -> ())!
    
    @IBOutlet weak var buttonFrequentlyAskedQuestion: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if labelVersion != nil {
            labelVersion.text = "Zabihah for iOS: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild)) "
        }
        
    }
    @IBAction func buttonPrivacyPolicy(_ sender: Any) {
        buttonPrivacyPolicyHandler?()
    }
    
    @IBAction func buttonAbout(_ sender: Any) {
        buttonAboutHandler?()
    }
    @IBAction func buttonFrequentlyAskedQuestion(_ sender: Any) {
        buttonFrequentlyAskQuestionHandler?()
    }
}

