//
//  LoginWithEmailOrPhoneViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/07/2024.
//

import UIKit
import FlagPhoneNumber
import Alamofire

class LoginWithEmailOrPhoneViewController: UIViewController {
    @IBOutlet weak var textFieldPhoneNumber: FPNTextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewBackGroundEmail: UIView!
    @IBOutlet weak var viewBackGroundPhoneNumber: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var imageViewTitleType: UIImageView!
    @IBOutlet weak var viewBackGroundButtonSendVerificationCode: UIView!
    @IBOutlet weak var buttonSendVerificationCode: UIButton!
    @IBOutlet weak var stackViewEmail: UIView!
    @IBOutlet weak var stackViewPhoneNumber: UIView!
    
    var isFromEmail: Bool = false

    var modelSendnotificationResponse: ModelSendnotificationResponse? {
        didSet {
            if modelSendnotificationResponse?.success ?? false {
                navigateToOtpLoginViewController()
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelSendnotificationResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEmail.text = "ahmedshakeelpk@gmail.com"
//        textFieldEmail.text = "projectapipk@gmail.com"
        textFieldPhoneNumber.text = "+923115284424"
        viewBackGroundEmail.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundPhoneNumber.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundButtonSendVerificationCode.radius(radius: 8)
        
        if isFromEmail {
            labelTitle.text = "Confirm your email"
            stackViewPhoneNumber.isHidden = true
        }
        else {
            labelTitle.text = "Confirm your phone"
            stackViewEmail.isHidden = true
            imageViewTitleType.image = UIImage(named: "phoneLogo")

            textFieldPhoneNumber.setFlag(countryCode: .US)
            textFieldPhoneNumber.delegate = self
            textFieldPhoneNumber.displayMode = .list // .picker by default
        }
    }

    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonSendVerificationCode(_ sender: Any) {
        if isFromEmail {
            if textFieldEmail.text == "" {
                self.showToast(message: "Enter Email!")
                return()
            }
        }
        else {
            if textFieldPhoneNumber.text == "" {
                self.showToast(message: "Enter Phone Number!")
                return()
            }
        }
        sendnotification()
    }
    
    func navigateToOtpLoginViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OtpLoginViewController") as! OtpLoginViewController
        vc.isFromEmail = isFromEmail
        vc.stringPhoneEmail = isFromEmail ? textFieldEmail.text! : textFieldPhoneNumber.text!
        if !(modelSendnotificationResponse?.recordNotFound ?? false) {
            vc.isRegisterationRequest = false
            vc.isOtpSuccessFullHandler = {
                self.navigateToHomeViewController()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToHomeViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.home.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationHomeViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
        
//        let vc = UIStoryboard.init(name: StoryBoard.name.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendnotification() {
        let parameters: Parameters = [
            "recipient": isFromEmail ? textFieldEmail.text! : textFieldPhoneNumber.text!,
            "device": isFromEmail ? "email" : "phone"
        ]
        
        APIs.postAPI(apiName: .sendnotification, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelSendnotificationResponse = model
        }
    }
}

extension LoginWithEmailOrPhoneViewController: FPNTextFieldDelegate {

   /// The place to present/push the listController if you choosen displayMode = .list
   func fpnDisplayCountryList() {
       let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

       textFieldPhoneNumber.displayMode = .list // .picker by default
       listController.setup(repository: textFieldPhoneNumber.countryRepository)
       listController.didSelect = { [weak self] country in
           self?.textFieldPhoneNumber.setFlag(countryCode: country.code)
           
       }
//       self.present(listController, animated: true, completion: nil)
       let navigationViewController = UINavigationController(rootViewController: listController)
       listController.title = "Countries"
       self.present(navigationViewController, animated: true, completion: nil)
   }

   /// Lets you know when a country is selected
   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print(name, dialCode, code) // Output "France", "+33", "FR"
   }

   /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
      if isValid {
         // Do something...
//          textFieldPhoneNumber.getFormattedPhoneNumber(format: .E164),           // Output "+33600000001"
//          textFieldPhoneNumber.getFormattedPhoneNumber(format: .International),  // Output "+33 6 00 00 00 01"
//          textFieldPhoneNumber.getFormattedPhoneNumber(format: .National),       // Output "06 00 00 00 01"
//          textFieldPhoneNumber.getFormattedPhoneNumber(format: .RFC3966),        // Output "tel:+33-6-00-00-00-01"
//          textFieldPhoneNumber.getRawPhoneNumber()                               // Output "600000001"
      } else {
         // Do something...
      }
   }
}
