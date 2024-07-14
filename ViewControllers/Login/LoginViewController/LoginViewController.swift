//
//  ViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 03/07/2024.
//

import UIKit
import AZSClient
import Alamofire


class LoginViewController: UIViewController {

    @IBOutlet weak var viewBackGroundEmail: UIView!
    @IBOutlet weak var viewBackGroundPhone: UIView!
    @IBOutlet weak var viewBackGroundFaceBook: UIView!
    @IBOutlet weak var viewBackGroundApple: UIView!
    
    
    @IBOutlet weak var buttonEmailLogin: UIButton!
    @IBOutlet weak var buttonPhoneLogin: UIButton!
    @IBOutlet weak var buttonAppleLogin: UIButton!
    @IBOutlet weak var buttonFaceBookLogin: UIButton!
    

    override func viewDidAppear(_ animated: Bool) {

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "zabihah"
        

        self.view.backgroundColor = .white
        setStatusBarTopColor(color: .clrWhiteStatusBar)
        viewBackGroundEmail.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundPhone.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundFaceBook.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundApple.radius(radius: 8, color: .clrBorder, borderWidth: 1)
    }
    
    @IBAction func buttonEmailLogin(_ sender: Any) {
        navigateToLoginWithEmailOrPhoneViewController(isFromEmail: true)
    }
    @IBAction func buttonPhoneLogin(_ sender: Any) {
        navigateToHomeViewController()
//        navigateToLoginWithEmailOrPhoneViewController(isFromEmail: false)
    }
    @IBAction func buttonFaceBookLogin(_ sender: Any) {
    }
    @IBAction func buttonAppleLogin(_ sender: Any) {
    }
    
    func navigateToLoginWithEmailOrPhoneViewController(isFromEmail: Bool) {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "LoginWithEmailOrPhoneViewController") as! LoginWithEmailOrPhoneViewController
        vc.isFromEmail = isFromEmail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToRegisterationViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "RegisterationViewController") as! RegisterationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToProfileViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToHomeViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddAddressFieldsViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressFieldsViewController") as! AddAddressFieldsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToProfileDeleteViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileDeleteViewController") as! ProfileDeleteViewController
        vc.buttonDeleteHandler = {
            print("delete button press")
        }
        self.present(vc, animated: true)
    }
   
}
