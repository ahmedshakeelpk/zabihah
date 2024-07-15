//
//  OtpLoginViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/07/2024.
//

import UIKit
import Alamofire

class OtpLoginViewController: UIViewController{
    
    @IBOutlet weak var viewTextFieldOtp: OTPFieldView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var viewBackGroundButtonContinue: UIView!
    @IBOutlet weak var viewBackGroundButtonResend: UIView!
    @IBOutlet weak var buttonResend: UIButton!
    @IBOutlet weak var imageViewTitleType: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContactType: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelResendCodeTimer: UILabel!
  
    var otpString = ""
    var resendCodeCounter = 5
    var resendCodeTimer = Timer()
    var isFromEmail: Bool = false
    var isFromRegistrationViewController: Bool = false
    var stringPhoneEmail = ""
    var isRegisterationRequest: Bool = true
    
    var isOtpSuccessFullHandler: (() -> ())!
    var modelOtpResponse: ModelOtpResponse? {
        didSet {
            if modelOtpResponse?.success ?? false {
                if isFromRegistrationViewController {
                    popViewController(animated: false)
                    DispatchQueue.main.async {
                        self.isOtpSuccessFullHandler?()
                    }
                }
                else if !isRegisterationRequest {
                    kAccessToken = modelOtpResponse?.token ?? ""
                    kDefaults.set(kAccessToken, forKey: "kAccessToken")
                    popViewController(animated: false)
                    DispatchQueue.main.async {
                        self.isOtpSuccessFullHandler?()
                    }
                }
                else {
                    showAlertCustomPopup(title: "Success", message: modelOtpResponse?.message ?? "", iconName: .iconSuccess) { _ in
                        self.navigateToRegisterationViewController()
                    }
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelOtpResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    var modelSendnotificationResponse: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? {
        didSet {
            if modelSendnotificationResponse?.success ?? false {
                startOtpTimer()
                DispatchQueue.main.async {
                    self.showAlertCustomPopup(title: "Success", message: self.modelSendnotificationResponse?.message ?? "", iconName: .iconSuccess)
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelSendnotificationResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        labelContactType.text = stringPhoneEmail
        viewBackGroundButtonContinue.radius(radius: 8)
        viewBackGroundButtonResend.radius(radius: 8)
        
        viewBackGroundButtonResend.backgroundColor = .clrDarkBlueWithOccupacy05
        setupOtpViewConfiguration()
        startOtpTimer()
        if isFromEmail {
            labelTitle.text = "Confirm your email"
//            labelContactType.text = "email@domain.com"
        }
        else {
            labelTitle.text = "Confirm your phone"
//            labelContactType.text = " +1 (555) 000-0000"
            imageViewTitleType.image = UIImage(named: "phoneVerificationLogin")
        }
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonContinue(_ sender: Any) {
        if otpString != "" {
            verifyOtp()
        }
        else {
            self.showToast(message: "Enter OTP!")
        }
    }
    
    @IBAction func buttonResend(_ sender: Any) {
        sendnotification()
    }
    
    func navigateToRegisterationViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "RegisterationViewController") as! RegisterationViewController
        vc.isFromEmail = isFromEmail
        vc.stringPhoneEmail = stringPhoneEmail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupOtpViewConfiguration() {
        self.viewTextFieldOtp.fieldsCount = 4
        self.viewTextFieldOtp.fieldBorderWidth = 2
        self.viewTextFieldOtp.fieldPlaceHolder = "0"
        self.viewTextFieldOtp.defaultBorderColor = .clrBorder
        self.viewTextFieldOtp.filledBorderColor = .clrBorder
        self.viewTextFieldOtp.fieldTextColor = .clrApp
        self.viewTextFieldOtp.cursorColor = .clrApp
        self.viewTextFieldOtp.displayType = .roundedCorner
        self.viewTextFieldOtp.fieldSize = 65
        self.viewTextFieldOtp.separatorSpace = 8
        self.viewTextFieldOtp.shouldAllowIntermediateEditing = false
        self.viewTextFieldOtp.delegate = self
        self.viewTextFieldOtp.initializeUI()
    }
    
    
    //Resend Code Timer Functionality *********
    // in case user closed the controller
     deinit {
       resendCodeTimer.invalidate()
     }
    func startOtpTimer() {
        resendCodeCounter = 5
        buttonResend.isEnabled = false
        labelResendCodeTimer.text = ""
        viewBackGroundButtonResend.backgroundColor = .clrDarkBlueWithOccupacy05

        self.resendCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
    }
    @objc func updateTimerLabel() {
        resendCodeCounter -= 1
        labelResendCodeTimer.text = "Resend in \(resendCodeCounter) seconds"
        print("Resend in \(resendCodeCounter) seconds")
        if resendCodeCounter == 0 {
            buttonResend.isEnabled = true
            resendCodeTimer.invalidate()
            labelResendCodeTimer.text = "Resend Verification Code"
            viewBackGroundButtonResend.backgroundColor = .clrLightBlue
        }
    }
    //Resend Code Timer Functionality *********
    
    
    
    func verifyOtp() {
        let parameters: Parameters = [
            "otp": otpString
        ]
        
        APIs.postAPI(apiName: .verifyOtp, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelOtpResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelOtpResponse = model
        }
    }
    func sendnotification() {
        print()
        var deviceType = ""
        if isFromRegistrationViewController {
            deviceType = isFromEmail ? "phone" : "email"
        }
        else {
            deviceType = isFromEmail ? "email" : "phone"
        }
        let parameters: Parameters = [
            "recipient": stringPhoneEmail,
            "device": deviceType
        ]
        
        APIs.postAPI(apiName: .sendnotification, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelSendnotificationResponse = model
        }
    }
}
extension OtpLoginViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        
        return true
    }
    
    func enteredOTP(otp: String) {
        print(otp)
        otpString = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        
        return true
    }
}
