//
//  LocationDescriptionBottomSheet.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/10/2024.
//

import UIKit

class LocationDescriptionBottomSheet: UIViewController {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewButtonPrivacyPolicyBackGround: ViewBackGroundContinueButton!
    @IBOutlet weak var viewButtonContinueBackGround: ViewBackGroundContinueButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonPrivacyPolicy: UIButton!
    
    var buttonPrivacyPolicyHandler: (() -> ())!
    var buttonContinueHandler: (() -> ())!
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewButtonPrivacyPolicyBackGround.radius(radius: 8, color: .clrBlack, borderWidth: 1)
        viewButtonContinueBackGround.radius(radius: 8)
        let text = labelDescription.text!
        labelDescription.setTwoSizeText(textFirst: text, textSecond: "privacy policy")
    }
    @IBAction func buttonContinue(_ sender: Any) {
        self.dismiss(animated: true) {
            self.buttonContinueHandler?()
        }
    }
    @IBAction func buttonPrivacyPolicy(_ sender: Any) {
        self.dismiss(animated: true) {
            self.buttonPrivacyPolicyHandler?()
        }
    }
    

}
