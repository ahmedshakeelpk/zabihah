//
//  EditEmailPhoneViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import FlagPhoneNumber
import Alamofire

class EditEmailPhoneViewController: UIViewController {

    @IBOutlet weak var textFieldPhoneNumber: FPNTextField!
    @IBOutlet weak var buttonSendVerificationCode: UIButton!
    @IBOutlet weak var viewBackGroundButtonSend: UIView!
    @IBOutlet weak var viewBackGroundEmail: UIView!
    @IBOutlet weak var viewBackGroundPhoneNumber: UIView!
    @IBOutlet weak var stackViewPhoneNumber: UIStackView!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    
    var isFromEmail: Bool = false
    var isOtpVerified = false
    var editProfileResponseHandler: (() -> ())!

    var modelSendnotificationResponse: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? {
        didSet {
            if modelSendnotificationResponse?.success ?? false {
                navigateToOtpEmailViewController()
            }
            else {
                showAlertCustomPopup(title: "Error!", message: modelSendnotificationResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
        editprofile()
    }
    
    func setConfiguration() {
        textFieldEmail.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        textFieldPhoneNumber.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        
        viewBackGroundButtonSend.radius(radius: 8)
        viewBackGroundEmail.radius(radius: 8, color: .colorBorder, borderWidth: 1)
        viewBackGroundPhoneNumber.radius(radius: 8, color: .colorBorder, borderWidth: 1)
        labelEmail.text = ""
        
        if isFromEmail {
            stackViewPhoneNumber.isHidden = true
        }
        else {
            stackViewEmail.isHidden = true
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
        viewBackGroundButtonSend.backgroundColor = isValid ? .clrLightBlue : .clrDisableButton
    }
    
    func navigateToOtpEmailViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OtpEmailViewController") as! OtpEmailViewController
        vc.isFromEmail = isFromEmail
        vc.stringPhoneEmail = isFromEmail ? textFieldEmail.text! : textFieldPhoneNumber.getCompletePhoneNumber()
        vc.isOtpSuccessFullHandler = {
            self.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.editProfileResponseHandler?()
            }
//            self.editprofile()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendnotification() {
        let parameters: Parameters = [
            "phone": isFromEmail ? "" : textFieldPhoneNumber.getCompletePhoneNumber(),
            "email": isFromEmail ? textFieldEmail.text! : "",
            "type": isFromEmail ? OtpRequestType.email.rawValue : OtpRequestType.phone.rawValue
        ]
        
        APIs.postAPI(apiName: .request, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            if statusCode == 200 && responseData == nil {
                let model = LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse(recordFound: nil, success: true, message: "", innerExceptionMessage: nil)
                self.modelSendnotificationResponse = model
            }
            else {
                let model: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
                self.modelSendnotificationResponse = model
            }
        }
    }
    
    var modelEditProfileResponse: EditNameViewController.ModelEditProfileResponse? {
        didSet {
            if modelEditProfileResponse?.success ?? false {
                sendnotification()
//                if self.isFromEmail {
//                    kModelGetUserProfileResponse?.email = self.textFieldEmail.text!
//                }
//                else {
//                    kModelGetUserProfileResponse?.phone = self.textFieldPhoneNumber.getCompletePhoneNumber()
//                }
//                self.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.editProfileResponseHandler?()
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelEditProfileResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    func editprofile() {
        let parameters: Parameters = [
            "firstname": kModelGetUserProfileResponse?.firstName ?? "",
            "lastName": kModelGetUserProfileResponse?.lastName! ?? "",
            "email": isFromEmail ? textFieldEmail.text! : kModelGetUserProfileResponse?.email ?? "",
            "phone": isFromEmail ? kModelGetUserProfileResponse?.phone ?? "": textFieldEmail.text! ,
            "profilePictureWebUrl": kModelGetUserProfileResponse?.profilePictureWebUrl ?? "",
            "isSubscribedToHalalOffersNotification": kModelGetUserProfileResponse?.isSubscribedToHalalEventsNewsletter ?? "",
            "isSubscribedToHalalEventsNewsletter": kModelGetUserProfileResponse?.isSubscribedToHalalOffersNotification ?? ""
        ]
        APIs.postAPI(apiName: .updateUser, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg, statusCode in
            if statusCode == 200 && responseData == nil {
                let model = EditNameViewController.ModelEditProfileResponse(success: true, message: "", recordFound: false, innerExceptionMessage: "", userResponseData: nil)
                self.modelEditProfileResponse = model
            }
            else {
                let model: EditNameViewController.ModelEditProfileResponse? = APIs.decodeDataToObject(data: responseData)
                self.modelEditProfileResponse = model
            }
        }
    }
}

extension EditEmailPhoneViewController: FPNTextFieldDelegate {

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
