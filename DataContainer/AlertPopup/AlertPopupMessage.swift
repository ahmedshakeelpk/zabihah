//
//  AlertPopupMessage.swift
//  First Pay
//
//  Created by Apple on 06/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class AlertPopupMessage: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var viewButtonOne: UIView!
    @IBOutlet weak var viewButtonOneInner: UIView!
    @IBOutlet weak var labelButtonOne: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    
    
    
    @IBOutlet weak var viewButtonTwo: UIView!
    @IBOutlet weak var viewButtonTwoInner: UIView!
    @IBOutlet weak var labelButtonTwo: UILabel!
    @IBOutlet weak var buttonTwo: UIButton!
    
    @IBOutlet weak var viewButtonThree: UIView!
    @IBOutlet weak var viewButtonThreeInner: UIView!
    @IBOutlet weak var labelButtonThree: UILabel!
    @IBOutlet weak var buttonThree: UIButton!
    
    @IBOutlet weak var imageViewMessageIcon: UIImageView!
    @IBOutlet weak var viewButtonFour: UIView!
    @IBOutlet weak var viewButtonFourInner: UIView!
    @IBOutlet weak var labelButtonFour: UILabel!
    @IBOutlet weak var buttonFour: UIButton!
    
    @IBOutlet weak var viewButtonFive: UIView!
    @IBOutlet weak var viewButtonFiveInner: UIView!
    @IBOutlet weak var labelButtonFive: UILabel!
    @IBOutlet weak var buttonFive: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelErrorCode: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    
    var titleMessage = ""
    var message = ""
    //Sample Button Array
//    ["buttonName": "",
//     "buttonBackGroundColor": UIColor,
//     "buttonTextColor": UIColor
//    ]
    var arrayButtonNames = [[String: AnyObject]]()
    var complitionButtonAction: ((String)->())!
    
    var iconName = ""
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.drawBackgroundBlur(withTag: 999)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBackGround.radius(radius: 40)
        setUISetting()
        
        if iconName != "" {
            imageViewMessageIcon.image = UIImage(named: iconName)
        }
        else {
            //Default Icon
        }
        labelTitle.text = titleMessage
        labelDescription.text = message
        labelErrorCode.text = ""
        
        
    }
    @IBAction func buttonFive(_ sender: Any) {
        buttonPressed(buttonNumber: 4)
    }
    @IBAction func buttonFour(_ sender: Any) {
        buttonPressed(buttonNumber: 3)
    }
    @IBAction func buttonThree(_ sender: Any) {
        buttonPressed(buttonNumber: 2)
    }
    @IBAction func buttonTwo(_ sender: Any) {
        buttonPressed(buttonNumber: 1)
    }
    @IBAction func buttonOne(_ sender: Any) {
        buttonPressed(buttonNumber: 0)
    }
    
    func setUISetting() {
        viewButtonTwo.isHidden = true
        viewButtonThree.isHidden = true
        viewButtonFour.isHidden = true
        viewButtonFive.isHidden = true
        //MARK: - Sample
//        ["buttonName": "",
//         "buttonBackGroundColor": UIColor,
//         "buttonTextColor": UIColor
//        ]
        for (index, buttonName) in arrayButtonNames.enumerated() {
            if index == 0 {
                labelButtonOne.text = buttonName["buttonName"] as? String
                labelButtonOne.textColor = buttonName["buttonTextColor"] as? UIColor
                viewButtonOneInner.backgroundColor = buttonName[
                    "buttonBackGroundColor"] as? UIColor
            }
            if index == 1 {
                viewButtonTwo.isHidden = false
                
                labelButtonTwo.text = buttonName["buttonName"] as? String
                labelButtonTwo.textColor = buttonName["buttonTextColor"] as? UIColor
                viewButtonTwoInner.backgroundColor = buttonName[
                    "buttonBackGroundColor"] as? UIColor
            }
            if index == 2 {
                viewButtonThree.isHidden = false
                
                labelButtonThree.text = buttonName["buttonName"] as? String
                labelButtonThree.textColor = buttonName["buttonTextColor"] as? UIColor
                viewButtonThreeInner.backgroundColor = buttonName[
                    "buttonBackGroundColor"] as? UIColor
            }
            if index == 3 {
                viewButtonFour.isHidden = false
                
                labelButtonFour.text = buttonName["buttonName"] as? String
                labelButtonFour.textColor = buttonName["buttonTextColor"] as? UIColor
                viewButtonFourInner.backgroundColor = buttonName[
                    "buttonBackGroundColor"] as? UIColor
            }
            if index == 4 {
                viewButtonFive.isHidden = false
                
                labelButtonFive.text = buttonName["buttonName"] as? String
                labelButtonFive.textColor = buttonName["buttonTextColor"] as? UIColor
                viewButtonFiveInner.backgroundColor = buttonName[
                    "buttonBackGroundColor"] as? UIColor
            }
        }
        viewButtonOneInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonOneInner.circle()
        viewButtonTwoInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonTwoInner.circle()
        viewButtonThreeInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonThreeInner.circle()
        viewButtonFourInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonFourInner.circle()
        viewButtonFiveInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonFiveInner.circle()
        

    }
    
    func buttonPressed(buttonNumber: Int) {
        let buttonName = self.arrayButtonNames[buttonNumber]["buttonName"] as? String ?? "Error Button"
        self.view.backgroundColor = .clear
        view.viewWithTag(999)?.removeFromSuperview()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
            self.complitionButtonAction?(buttonName)
        }
    }
    
    


}
