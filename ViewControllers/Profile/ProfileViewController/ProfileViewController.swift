//
//  ProfileViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/07/2024.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var viewBackGroundNameTitle: UIView!
    @IBOutlet weak var stackViewNewAndUpdate: UIStackView!
    @IBOutlet weak var stackViewSocialLogin: UIStackView!
    @IBOutlet weak var stackViewDangerZone: UIStackView!
    @IBOutlet weak var stackViewName: UIStackView!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var stackViewPhone: UIStackView!
    
    @IBOutlet weak var buttonEditPhoneNumber: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonEditName: UIButton!
    @IBOutlet weak var buttonEditEmail: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonEditName(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditNameViewController") as! EditNameViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonEditEmail(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditEmailPhoneViewController") as! EditEmailPhoneViewController
        vc.isFromEmail = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonEditPhoneNumber(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditEmailPhoneViewController") as! EditEmailPhoneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
