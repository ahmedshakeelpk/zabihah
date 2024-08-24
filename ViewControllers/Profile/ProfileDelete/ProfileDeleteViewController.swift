//
//  ProfileDeleteViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 13/07/2024.
//

import UIKit

class ProfileDeleteViewController: UIViewController {

    @IBOutlet weak var buttonDeleteMyAccount: UIButton!
    @IBOutlet weak var viewButtonDeleteMyAccountBackGround: UIView!
    @IBOutlet weak var viewButtonCancelBackGround: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var buttonDeleteHandler: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        viewButtonDeleteMyAccountBackGround.radius(radius: 8)
        viewButtonCancelBackGround.radius(color: .clrLightGray, borderWidth: 1)
    }
    @IBAction func buttonDeleteMyAccount(_ sender: Any) {
        self.dismiss(animated: true) {
            self.buttonDeleteHandler?()
        }
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
