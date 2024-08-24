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
    
    var modelUserConfigurationResponse: HomeViewController.ModelUserConfigurationResponse? {
        didSet {
            kModelUserConfigurationResponse = modelUserConfigurationResponse
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if kAccessToken != "" {
            navigateToRootHomeViewController()
        }
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
        viewBackGroundEmail.radius(radius: 8, color: .colorBorder, borderWidth: 1)
        viewBackGroundPhone.radius(radius: 8, color: .colorBorder, borderWidth: 1)
        viewBackGroundFaceBook.radius(radius: 8, color: .colorBorder, borderWidth: 1)
        viewBackGroundApple.radius(radius: 8, color: .colorBorder, borderWidth: 1)
        
        userConfiguration()
    }
    
    @IBAction func buttonEmailLogin(_ sender: Any) {
        navigateToLoginWithEmailOrPhoneViewController(isFromEmail: true)
    }
    @IBAction func buttonPhoneLogin(_ sender: Any) {
//        navigateTogalleryStoryBoard()
        //        navigateToHomeViewController()
//        navigateToRatingViewController()
                navigateToLoginWithEmailOrPhoneViewController(isFromEmail: false)
    }
    @IBAction func buttonFaceBookLogin(_ sender: Any) {
    }
    @IBAction func buttonAppleLogin(_ sender: Any) {
    }
    
    
    func navigateTogalleryStoryBoard() {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToRatingViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
    func navigateToRootHomeViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.home.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationHomeViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
    func navigateToAddressesListViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddressesListViewController") as! AddressesListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToEditAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToProfileDeleteViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileDeleteViewController") as! ProfileDeleteViewController
        vc.buttonDeleteHandler = {
            print("delete button press")
        }
        self.present(vc, animated: true)
    }
    func navigateToDeliveryDetailsViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController") as! DeliveryDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToDeliveryDetails2ViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController2") as! DeliveryDetailsViewController2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToDeliveryDetails3ViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userConfiguration() {
        print(getCurrentTimeZone())
        let parameters: Parameters = [
            "timeZoneId": getCurrentTimeZone()
        ]
        APIs.postAPI(apiName: .userConfiguration, parameters: parameters, methodType: .post, viewController: self) { responseData, success, errorMsg in
            let model: HomeViewController.ModelUserConfigurationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelUserConfigurationResponse = model
        }
    }
    
    func getCurrentTimeZone() -> String {
        TimeZone.current.identifier
    }    
}
