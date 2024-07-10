//
//  RegisterationViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/07/2024.
//

import UIKit
import FlagPhoneNumber
import Alamofire

class RegisterationViewController: UIViewController {

    @IBOutlet weak var buttonAgree: UIButton!
    @IBOutlet weak var labelTermsAndConditions: UILabel!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: FPNTextField!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var viewBackGroundButtonContinue: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var stackViewPhoneNumber: UIView!
    @IBOutlet weak var viewBackGroundPhoneNumber: UIView!
    @IBOutlet weak var stackViewEmail: UIView!
    
    var isFromEmail: Bool = false
    var stringPhoneEmail = ""

    var modelSendnotificationResponse: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? {
        didSet {
            if modelSendnotificationResponse?.success ?? false {
                navigateToOtpLoginViewController()
            }
            else {
                showAlertCustomPopup(title: "Error!", message: modelSendnotificationResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    var modelSignUpResponse: ModelSignUpResponse? {
        didSet {
            if modelSendnotificationResponse?.success ?? false {
                navigateToHomeViewController()
            }
            else {
                showAlertCustomPopup(title: "Error!", message: modelSendnotificationResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBackGroundButtonContinue.radius(radius: 8)
        labelTermsAndConditions.setTwoColorWithUnderLine(textFirst: "I agree to ", textSecond: "terms and conditions.", colorFirst: .clrDarkBlue, colorSecond: .clrApp)
        if isFromEmail {
            viewBackGroundPhoneNumber.radius(radius: 4, color: .clrBorder, borderWidth: 0.5)
            //TODO: - need to uncomment below mentioned line
//            stackViewEmail.isHidden = true
            textFieldPhoneNumber.setFlag(countryCode: .US)
            textFieldPhoneNumber.delegate = self
            textFieldPhoneNumber.displayMode = .list // .picker by default
        }
        else {
            //TODO: - need to uncomment below mentioned line
//            stackViewPhoneNumber.isHidden = true
        }
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonEdit(_ sender: Any) {
    }
    @IBAction func buttonContinue(_ sender: Any) {
        if isOtpVerified {
            userSignup()
        }
        else {
            sendnotification()
        }
    }
    var isOtpVerified = false
    func navigateToOtpLoginViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OtpLoginViewController") as! OtpLoginViewController
        vc.isFromRegistrationViewController = true
        vc.stringPhoneEmail = stringPhoneEmail
        vc.isOtpSuccessFullHandler = {
            self.userSignup()
            self.isOtpVerified = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonAgree(_ sender: Any) {
    }
    
    func navigateToHomeViewController() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.home.rawValue, bundle:nil)
//        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationHomeViewController") as? UINavigationController {
//            self.sceneDelegate?.window?.rootViewController = navigationController
//        }
        
        let vc = UIStoryboard.init(name: StoryBoard.name.home.rawValue, bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userSignup() {
        let parameters: Parameters = [
            "firstname": textFieldFirstName.text!,
            "lastName": textFieldLastName.text!,
            "email": isFromEmail ? "" : textFieldEmail.text!,
            "phone": isFromEmail ? textFieldPhoneNumber.text! : "",
            "photo": "https://i.sstatic.net/Xofvk.png",
            "isNewsLetter": true
        ]
        
        APIs.postAPI(apiName: .userignup, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelSignUpResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelSignUpResponse = model
        }
    }
    
    func sendnotification() {
        let parameters: Parameters = [
            "recipient": isFromEmail ? textFieldEmail.text! : textFieldPhoneNumber.text!,
            "device": isFromEmail ? "email" : "phone"
        ]
        
        APIs.postAPI(apiName: .sendnotification, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelSendnotificationResponse = model
        }
    }
}

extension RegisterationViewController: FPNTextFieldDelegate {

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
