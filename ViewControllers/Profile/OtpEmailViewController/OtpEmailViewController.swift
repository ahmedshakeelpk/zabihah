//
//  OtpEmailViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import Alamofire

class OtpEmailViewController: UIViewController{
    
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
  
    var isOtpSuccessFullHandler: (() -> ())!
    var stringPhoneEmail = ""
    
    var resendCodeTimer = Timer()
    
    var isFromEmail: Bool = false
    var otpEntered: Bool! = false {
        didSet {
            buttonContinue.isEnabled = otpEntered
            viewBackGroundButtonContinue.backgroundColor = otpEntered ? .clrLightBlue : .clrDisableButton
        }
    }
    var resendCodeCounter = 50 {
        didSet {
            buttonResend.isEnabled = resendCodeCounter <= 0
            viewBackGroundButtonResend.backgroundColor = resendCodeCounter <= 0 ? .clrLightBlue : .clrDisableButton
            
            if resendCodeCounter <= 0 {
                resendCodeTimer.invalidate()
                labelResendCodeTimer.text = "Resend Verification Code"
            }
            else {
                labelResendCodeTimer.text = "Resend in \(resendCodeCounter) seconds"
//                print("Resend in \(resendCodeCounter) seconds")
            }
        }
    }
   
    var otpString: String!
    var modelOtpResponse: OtpLoginViewController.ModelOtpResponse? {
        didSet {
            if !(modelOtpResponse?.token ?? "").isEmpty {
                self.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isOtpSuccessFullHandler?()
                }
            }
            else {
                let errorMessage = getErrorMessage(errorMessage: modelOtpResponse?.title ?? "")

                showAlertCustomPopup(title: "Error", message: errorMessage, iconName: .iconError)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        otpEntered = false
        
        viewBackGroundButtonContinue.radius(radius: 8)
        viewBackGroundButtonResend.radius(radius: 8)
        viewBackGroundButtonResend.backgroundColor = .clrDisableButton
        setupOtpViewConfiguration()
        startOtpTimer()
        if isFromEmail {
            labelTitle.text = "Confirm your email"
        }
        else {
            labelTitle.text = "Confirm your phone"
            imageViewTitleType.image = UIImage(named: "phoneVerificationLogin")
        }
        labelContactType.text = stringPhoneEmail
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
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
    
    func setupOtpViewConfiguration() {
        self.viewTextFieldOtp.fieldsCount = 4
        self.viewTextFieldOtp.fieldBorderWidth = 2
        self.viewTextFieldOtp.fieldPlaceHolder = "0"
        self.viewTextFieldOtp.defaultBorderColor = .colorBorder
        self.viewTextFieldOtp.filledBorderColor = .colorBorder
        self.viewTextFieldOtp.fieldTextColor = .clrBlack
        self.viewTextFieldOtp.cursorColor = .colorApp
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
        resendCodeCounter = 50
        labelResendCodeTimer.text = ""

        self.resendCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
    }
    @objc func updateTimerLabel() {
        resendCodeCounter -= 1
    }
    //Resend Code Timer Functionality *********

    func verifyOtp() {
        let parameters: Parameters = [
            "code": otpString ?? "",
            "createJwt": true
        ]
        
        APIs.postAPI(apiName: .verifyOtp, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            if statusCode == 200 && responseData == nil {
                let responseModel = OtpLoginViewController.ModelOtpResponse(title: "", message: "", token: "test token", refreshToken: "")
                self.modelOtpResponse = responseModel
            }
            else {
                let model: OtpLoginViewController.ModelOtpResponse? = APIs.decodeDataToObject(data: responseData)
                self.modelOtpResponse = model
            }
        }
    }
    
    func sendnotification() {
        let parameters: Parameters = [
            "phone": isFromEmail ? "" : stringPhoneEmail,
            "email": isFromEmail ? stringPhoneEmail : "",
            "type": isFromEmail ? OtpRequestType.email.rawValue : OtpRequestType.phone.rawValue
        ]
        
        APIs.postAPI(apiName: .request, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            if statusCode == 200 && responseData == nil {
                self.startOtpTimer()
            }
            else {
                let model: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
                let errorMessage = getErrorMessage(errorMessage: model?.title ?? "")

                self.showAlertCustomPopup(title: "Error!", message: errorMessage, iconName: .iconError)
            }
        }
    }
}
extension OtpEmailViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        
        return true
    }
    
    func enteredOTP(otp: String) {
        print(otp)
        otpString = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        otpEntered = hasEnteredAll
        return true
    }
}

