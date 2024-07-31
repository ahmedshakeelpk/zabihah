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
            if (modelSendnotificationResponse?.success ?? false) {
                navigateToOtpLoginViewController()
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelSendnotificationResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        textFieldEmail.text = "ahmedshakeelpk@gmail.com"
//        textFieldEmail.text = "projectapipk@gmail.com"
//        textFieldPhoneNumber.text = "+923115284424"
        
        setConfiguration()
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
    
    func setConfiguration() {
        textFieldEmail.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        textFieldPhoneNumber.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        
        viewBackGroundEmail.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundPhoneNumber.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundButtonSendVerificationCode.radius(radius: 8)
        
        if isFromEmail {
            labelTitle.text = "Sign in with email"
            stackViewPhoneNumber.isHidden = true
            stackViewEmail.isHidden = false
            imageViewTitleType.image = UIImage(named: "smsLogin")
        }
        else {
            labelTitle.text = "Sign in with phone"
            stackViewEmail.isHidden = true
            stackViewPhoneNumber.isHidden = false
            imageViewTitleType.image = UIImage(named: "phoneLogo")

            textFieldPhoneNumber.setFlag(countryCode: .US)
            textFieldPhoneNumber.delegate = self
            textFieldPhoneNumber.displayMode = .list // .picker by default
        }
        
        fieldVilidation()
    }
    @objc func fieldVilidation() {
        var isValid = true
        if isFromEmail {
            if textFieldEmail.text == "" {
                isValid = false
            }
        }
        else {
            if textFieldPhoneNumber.text == "" {
                isValid = false
            }
        }
        buttonSendVerificationCode.isEnabled = isValid
        viewBackGroundButtonSendVerificationCode.backgroundColor = isValid ? .clrLightBlue : .clrDisableButton
    }
    
    func navigateToOtpLoginViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OtpLoginViewController") as! OtpLoginViewController
        vc.isFromEmail = isFromEmail
        vc.stringPhoneEmail = isFromEmail ? textFieldEmail.text! : textFieldPhoneNumber.getCompletePhoneNumber()
        vc.isOtpSuccessFullHandler = {
            self.navigateToRootHomeViewController()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRootHomeViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.home.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationHomeViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
    
    func sendnotification() {
        let parameters: Parameters = [
            "recipient": isFromEmail ? textFieldEmail.text! : textFieldPhoneNumber.getCompletePhoneNumber(),
            "device": isFromEmail ? "email" : "phone",
            "validate": false //it will check if user exist in DB
        ]
        
        APIs.postAPI(apiName: .sendnotification, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelSendnotificationResponse = model
        }
    }
    
    func userAlreadyExistFromRegistration() {
        isFromEmail = !isFromEmail
        setConfiguration()
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
