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
    
    @IBOutlet weak var imageViewUser: UIImageView!
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
    
    var isOtpVerified = false
    var isFromEmail: Bool = false
    var stringPhoneEmail = ""
    var isImageUploaded = false {
        didSet {
            fieldVilidation()
        }
    }
    var modelGetBlobToken: ModelGetBlobToken? {
        didSet{
            
        }
    }
    
    var modelSendnotificationResponse: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? {
        didSet {
            if modelSendnotificationResponse?.success ?? false {
                navigateToOtpLoginViewController()
            }
            else {
                let errorMessage = getErrorMessage(errorMessage: modelSendnotificationResponse?.title ?? "")
                showAlertCustomPopup(title: "Error!", message: errorMessage, iconName: .iconError, buttonNames: [
                    [
                        "buttonName": "Cancel",
                        "buttonBackGroundColor": UIColor.white,
                        "buttonTextColor": UIColor.colorRed] as [String : Any],
                    [
                        "buttonName": "LogIn",
                        "buttonBackGroundColor": UIColor.colorRed,
                        "buttonTextColor": UIColor.white]
                ] as? [[String: AnyObject]]) {buttonName in
                    if buttonName == "Cancel" {
                        
                    }
                    else if buttonName == "LogIn" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if let viewController = self.popToViewController(viewController: LoginWithEmailOrPhoneViewController.self) {
                                if let targetViewController = viewController as? LoginWithEmailOrPhoneViewController {
                                    targetViewController.userAlreadyExistFromRegistration()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var modelSignUpResponse: ModelSignUpResponse? {
        didSet {
            if modelSignUpResponse?.success ?? false {
                sendnotification()
            }
            else {
                let errorMessage = getErrorMessage(errorMessage: modelSignUpResponse?.title ?? "")
                showAlertCustomPopup(title: "Error!", message: errorMessage, iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
        getBlobToken()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonEdit(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
                //here is the image
            self.imageViewUser.image = image
            self.isImageUploaded = true
        }
    }
    
    @IBAction func buttonContinue(_ sender: Any) {
        if let token = self.modelGetBlobToken?.uri {
            if isImageUploaded {
                self.uploadOnBlob(token: token)
            }
            else {
                self.userSignup()
            }
        }
        else {
            getBlobToken()
        }
        
        return()
        if isOtpVerified {
            if let token = self.modelGetBlobToken?.uri {
                if isImageUploaded {
                    self.uploadOnBlob(token: token)
                }
                else {
                    self.userSignup()
                }
            }
            else {
                getBlobToken()
            }
        }
        else {
            sendnotification()
        }
    }
    
    func setConfiguration() {
        textFieldEmail.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        textFieldLastName.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        textFieldFirstName.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        fieldVilidation()
        
        imageViewUser.circle()
        labelTermsAndConditions.setTwoColorWithUnderLine(textFirst: "I agree to ", textSecond: "terms and conditions.", colorFirst: .clrDarkBlue, colorSecond: .colorApp)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunctionOnLabel))
        labelTermsAndConditions.isUserInteractionEnabled = true
        labelTermsAndConditions.addGestureRecognizer(tap)
        
        if isFromEmail {
            viewBackGroundPhoneNumber.radius(radius: 4, color: .colorBorder, borderWidth: 0.5)
            stackViewEmail.isHidden = true
            textFieldPhoneNumber.setFlag(countryCode: .US)
            textFieldPhoneNumber.delegate = self
            textFieldPhoneNumber.displayMode = .list // .picker by default
            textFieldEmail.text = stringPhoneEmail
        }
        else {
            textFieldPhoneNumber.text = stringPhoneEmail
            stackViewPhoneNumber.isHidden = true
        }
        getBlobToken()
    }
    @objc
    func tapFunctionOnLabel(sender:UITapGestureRecognizer) {
        if let url = URL(string: "https://www.zabihah.com/com/tos") {
            UIApplication.shared.open(url)
        }
    }
    @objc func fieldVilidation() {
        var isValid = true
        if textFieldFirstName.text == "" {
            isValid = false
        }
        else if textFieldLastName.text == "" {
            isValid = false
        }
        else if isFromEmail ? textFieldPhoneNumber.text == "" : textFieldEmail.text == "" {
            isValid = false
        }
//        else if !isImageUploaded {
//            isValid = false
//        }
        else if buttonAgree.tag == 0 {
            isValid = false
        }
        buttonContinue.isEnabled = isValid
        viewBackGroundButtonContinue.backgroundColor = isValid ? .clrLightBlue : .clrDisableButton
    }
    
    func navigateToOtpLoginViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OtpLoginViewController") as! OtpLoginViewController
        vc.isFromRegistrationViewController = true
        vc.stringPhoneEmail = isFromEmail ? textFieldPhoneNumber.getCompletePhoneNumber() : textFieldEmail.text!
        vc.isOtpSuccessFullHandler = {
            kDefaults.set(kAccessToken, forKey: "kAccessToken")
            kDefaults.set(kRefreshToken, forKey: "kRefreshToken")
            self.navigateToRootHomeViewController()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToRootLoginViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.login.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationLoginViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
    @IBOutlet weak var imageViewCheck: UIImageView!
    @IBAction func buttonAgree(_ sender: Any) {
        if buttonAgree.tag == 0 {
            buttonAgree.tag = 1
            imageViewCheck.image = UIImage(named: "checkLogin")
        }
        else {
            imageViewCheck.image = UIImage(named: "unCheckLogin")
            buttonAgree.tag = 0
        }
        fieldVilidation()
    }
    
    func navigateToRootHomeViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.home.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationHomeViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }

    func userSignup(imageUrl: String? = "") {
        let parameters: Parameters = [
            "firstname": textFieldFirstName.text!,
            "lastName": textFieldLastName.text!,
            "email": isFromEmail ? stringPhoneEmail : textFieldEmail.text!,
            "phone": isFromEmail ? textFieldPhoneNumber.getCompletePhoneNumber() : stringPhoneEmail,
            "profilePictureWebUrl": imageUrl!,
            "isSubscribedToHalalOffersNotification": true,
            "isSubscribedToHalalEventsNewsletter": true,
        ]
        
        APIs.postAPI(apiName: .updateUser, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg, statusCode in
            
            if statusCode ==  200 && responseData == nil {
                let responseModel = ModelSignUpResponse(success: true, title: "", message: "", userResponseData: nil, recordFound: true, innerExceptionMessage: "",  token: "")
                self.modelSignUpResponse = responseModel
            }
            else {
                let model: ModelSignUpResponse? = APIs.decodeDataToObject(data: responseData)
                self.modelSignUpResponse = model
            }
        }
    }
    
    func sendnotification() {
        let parameters: Parameters = [
            "phone": isFromEmail ? textFieldPhoneNumber.getCompletePhoneNumber() : "",
            "email": isFromEmail ? "" : textFieldEmail.text!,
            "type": isFromEmail ? OtpRequestType.phone.rawValue : OtpRequestType.email.rawValue
        ]
        
        APIs.postAPI(apiName: .request, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            
            if statusCode ==  200 && responseData == nil {
                let responseModel = LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse(title: "", recordFound: true, success: true, message: "", innerExceptionMessage: "")
                self.modelSendnotificationResponse = responseModel
            }
            else {
                let model: LoginWithEmailOrPhoneViewController.ModelSendnotificationResponse? = APIs.decodeDataToObject(data: responseData)
                self.modelSendnotificationResponse = model
            }
            
        }
    }
    
    func openDocumentPicker() {
        //        let types: [String] = [
        //            kUTTypeJPEG as String,
        //            kUTTypePNG as String,
        ////                        "com.microsoft.word.doc",
        //            //            "org.openxmlformats.wordprocessingml.document",
        //            //            kUTTypeRTF as String,
        ////                        "com.microsoft.powerpoint.​ppt",
        //            //            "org.openxmlformats.presentationml.presentation",
        //            //            kUTTypePlainText as String,
        ////                        "com.microsoft.excel.xls",
        //            //            "org.openxmlformats.spreadsheetml.sheet",
        //                        kUTTypePDF as String,
        //            //            kUTTypeMP3 as String
        //        ]
        //        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        //        documentPicker.delegate = self
        //        documentPicker.modalPresentationStyle = .formSheet
        //        self.present(documentPicker, animated: true, completion: nil)
    }

    func getBlobToken() {
        APIs.getAPI(apiName: .getBlobTokenForUser, parameters: nil, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelGetBlobToken? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBlobToken = model
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
            fieldVilidation()
        } else {
            // Do something...
            fieldVilidation()
        }
    }
}

///Blob Upload Storage
extension RegisterationViewController {
    func uploadOnBlob(token: String) {
        uploadImageToBlobStorage(token: token, image: imageViewUser.image!)
    }
    
    func uploadImageToBlobStorage(token: String, image: UIImage) {
        //        let containerURL = "https://zabihahblob.blob.core.windows.net/profileimage"//containerName
        let currentDate1 = Date()
        let blobName = String(currentDate1.timeIntervalSinceReferenceDate)+".png"
        
        let tempToken = token.components(separatedBy: "?")
        
        let sasToken = tempToken.last ?? ""
        let containerURL = "\(tempToken.first ?? "")"
        print("containerURL with SAS: \(containerURL) ")
        
        let azureBlobStorage = AzureBlobStorage(containerURL: containerURL, sasToken: sasToken)
        azureBlobStorage.uploadImage(image: image, blobName: blobName) { success, error in
            if success {
                print("Image uploaded successfully!")
                if let imageURL = azureBlobStorage.getImageURL(containerURL: containerURL, blobName: blobName) {
                    print("Image URL: \(imageURL)")
                    DispatchQueue.main.async {
                        self.userSignup(imageUrl: "\(imageURL)")
                    }
                } else {
                    print("Failed to construct image URL")
                }
            } else {
                print("Failed to upload image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        return()
    }
}

//extension RegisterationViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    //Document
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        if let filename = urls.first?.lastPathComponent {
//            do {
//                for url in urls {
//                    let fileData = try Data(contentsOf: url)
//                }
//            } catch {
//                print("no data")
//            }
//        }
//        
//        // display picked file in a view
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageViewUser.image = image
//            isImageUploaded = true
////            if let imageData = image.jpegData(compressionQuality: 0.75) {
////                //                let fileData = imageData
////            }
////            
////            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
////                //                let fileName = imageUrl.lastPathComponent
////            }
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//    //Image Picker
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
//            imageViewUser.image = image
//            if let imageData = image.jpegData(compressionQuality: 0.75) {
//                //                let fileData = imageData
//            }
//            
//            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL {
//                //                let fileName = imageUrl.lastPathComponent
//            }
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}


