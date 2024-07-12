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

    var modelGetBlobContainer: ModelGetBlobContainer? {
        didSet {
            print(modelGetBlobContainer?.token)
            
        }
    }
    
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
    
    var modelGetUserResponseLocal: ModelGetUserResponse? {
        didSet {
            modelGetUserResponse = modelGetUserResponseLocal
        }
    }
    
    var modelSignUpResponse: ModelSignUpResponse? {
        didSet {
            if modelSignUpResponse?.success ?? false {
//                navigateToHomeViewController()
                if let token = modelSignUpResponse?.token {
                    kAccessToken = token
                    self.getuser()
                }
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
        getblobcontainer()
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonEdit(_ sender: Any) {
        if let token = modelGetBlobContainer?.token {
            uploadOnBlob(token: token)
        }
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
            "email": !isFromEmail ? "" : textFieldEmail.text!,
            "phone": "03219525316",// isFromEmail ? textFieldPhoneNumber.text! : "",
            "photo": "https://zabihahblob.blob.core.windows.net/profileimage/742473352.835877.jpg",
            "isNewsLetter": true
        ]
        
        APIs.postAPI(apiName: .usersignup, parameters: parameters, viewController: self) { responseData, success, errorMsg in
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
    
    
    func getuser() {
        let parameters: Parameters = [
            "containerName": "profileimage"
        ]
        APIs.postAPI(apiName: .getuser, parameters: parameters, httpMethod: .get) { responseData, success, errorMsg in
            print(responseData ?? "")
            print(success)
            let model: ModelGetUserResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
        }
    }
    
    
    
    func getblobcontainer() {
        let parameters: Parameters = [
            "containerName": "profileimage"
        ]
        
        APIs.postAPI(apiName: .getblobcontainer, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            print(responseData)
            print(success)
            let model: ModelGetBlobContainer? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBlobContainer = model
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


///Blob Upload Storage
extension RegisterationViewController {
    func uploadOnBlob(token: String) {
        let currentDate1 = Date()
        let fileName1 = String(currentDate1.timeIntervalSinceReferenceDate)+".jpg"
        uploadImageToBlobStorage(token: token, image: UIImage(named: "dummyFood")!, blobName: fileName1)
    }
    
    func uploadImageToBlobStorage(token: String, image: UIImage, blobName: String) {
        
//        let containerURL = "https://zabihahblob.blob.core.windows.net/profileimage"//containerName
        
        let tempToken = token.components(separatedBy: "?")
        
        let sasToken = tempToken.last ?? ""
        let containerURL = "\(tempToken.first ?? "")"
        print("containerURL with SAS: \(containerURL) ")
        
        let azureBlobStorage = AzureBlobStorage(containerURL: containerURL, sasToken: sasToken)
        
            azureBlobStorage.uploadImage(image: image, blobName: blobName) { success, error in
                if success {
                    print("Image uploaded successfully!")
                    if let imageURL = self.getImageURL(storageAccountName: "zabihahblob", containerName: containerName, blobName: blobName, sasToken: "") {
                        print("Image URL: \(imageURL)")
                    } else {
                        print("Failed to construct image URL")
                    }
                } else {
                    print("Failed to upload image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        return()


    }
    
    
    struct AzureBlobStorage {
        let containerURL: String
        let sasToken: String

        init(containerURL: String, sasToken: String) {
            self.containerURL = containerURL
            self.sasToken = sasToken
        }

        func uploadImage(image: UIImage, blobName: String, completion: @escaping (Bool, Error?) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
                return
            }

            let uploadURLString = "\(containerURL)/\(blobName)?\(sasToken)"
            guard let uploadURL = URL(string: uploadURLString) else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }

            var request = URLRequest(url: uploadURL)
            request.httpMethod = "PUT"
            request.setValue("BlockBlob", forHTTPHeaderField: "x-ms-blob-type")
            request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            request.httpBody = imageData

            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false, error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"]))
                    return
                }

                if httpResponse.statusCode == 201 {
                    completion(true, nil)
                } else {
                    let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image, status code: \(httpResponse.statusCode)"])
                    completion(false, statusCodeError)
                }
            }

            task.resume()
        }
    }
    
    // Function to construct the URL of the image in Azure Blob Storage
    func getImageURL(storageAccountName: String, containerName: String, blobName: String, sasToken: String? = nil) -> URL? {
        // Construct the base URL
        var urlString = "https://\(storageAccountName).blob.core.windows.net/\(containerName)/\(blobName)"
        
        // Append the SAS token if provided
        if let token = sasToken {
            if token != "" {
                urlString += "?\(token)"
            }
        }
        
        return URL(string: urlString)
    }
}
