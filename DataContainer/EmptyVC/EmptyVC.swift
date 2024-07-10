//
//  EmptyVC.swift
//  First Pay
//
//  Created by Apple on 10/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class EmptyVC: UIViewController {

    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelButtonName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewButtonBackGround: UIView!
    @IBOutlet weak var buttonAction: UIButton!
    
    
    var messageDescription = ""
    var buttonName = "OK"
    var iconName = "historyClockIcon"
    
    var callBackButtonAction: (()->())!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        labelDescription.text = messageDescription
        labelButtonName.text = buttonName
        imageViewIcon.image = UIImage(named: iconName)
//        self.viewButtonBackGround.radiusLineDashedStroke(radius: viewButtonBackGround.frame.height / 2 ,color: .clrLightGray)
    }

    @IBOutlet weak var viewBackGround: UIView!
    @IBAction func buttonAction(_ sender: Any) {
        callBackButtonAction?()
    }

}
