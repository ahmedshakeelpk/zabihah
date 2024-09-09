//
//  ProfileViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/07/2024.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet weak var buttonEditProfilePhoto: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var viewButtonEditBackGround: UIView!
    @IBOutlet weak var viewProfileImageBackGround: UIView!

    
    @IBOutlet weak var viewBackGroundNameTitle: UIView!
    @IBOutlet weak var stackViewNewAndUpdate: UIStackView!
    @IBOutlet weak var stackViewSocialLogin: UIStackView!
    @IBOutlet weak var stackViewDangerZone: UIStackView!
    @IBOutlet weak var stackViewName: UIStackView!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var stackViewPhone: UIStackView!
    @IBOutlet weak var buttonDeleteMyAccount: UIButton!
    
    @IBOutlet weak var viewLabelNameBackGround: UIView!
    @IBOutlet weak var viewTextFieldNameBackGround: UIView!
    @IBOutlet weak var viewLabelEmailBackGround: UIView!
    @IBOutlet weak var viewTextFieldEmailBackGround: UIView!
    @IBOutlet weak var viewTextFieldPhoneNumberbackGround: UIView!
    @IBOutlet weak var viewLabelPhoneNumberbackGround: UIView!
    @IBOutlet weak var viewFaceBookBackGround: UIView!
    @IBOutlet weak var viewAppleBackGround: UIView!
    @IBOutlet weak var viewSwitchOfferBackGround: UIView!
    @IBOutlet weak var viewSwitchEventsBackGround: UIView!
    
    @IBOutlet weak var buttonEditPhoneNumber: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonEditName: UIButton!
    @IBOutlet weak var buttonEditEmail: UIButton!
    
    @IBOutlet weak var switchOffers: UISwitch!{
        didSet{
            switchOffers.onTintColor = .colorApp
        }
    }
    @IBOutlet weak var switchHalalEvents: UISwitch!{
        didSet{
            switchHalalEvents.onTintColor = .colorApp
        }
    }
    @IBOutlet weak var viewTextFieldNameMainBackGround: UIView!
    @IBOutlet weak var viewTextFieldEmailMainBackGround: UIView!
    @IBOutlet weak var viewTextFieldPhoneNumberMainBackGround: UIView!
    
    
    var isUserImageUpdateCall: Bool? = false
    var modelEditProfileResponse: EditNameViewController.ModelEditProfileResponse? {
        didSet {
            getuser()
        }
    }
    
    var modelGetDeleteUserResponse: ModelGetDeleteUserResponse? {
        didSet {
            if modelGetDeleteUserResponse?.success ?? false {
                self.removeCacheData()
                self.navigateToRootViewController()
//                self.showAlertCustomPopup(title: "Success", message: self.modelGetDeleteUserResponse?.message ?? "", iconName: .iconSuccess) { _ in
//                    self.navigateToRootViewController()
//                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelGetDeleteUserResponse?.message ?? "", iconName: .iconError)
            }
        }
    }

    var modelGetUserResponseLocal: HomeViewController.ModelGetUserProfileResponse? {
        didSet {
            kModelGetUserProfileResponse = modelGetUserResponseLocal
            setData()
        }
    }
    
    var modelGetBlobToken: ModelGetBlobToken? {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewProfile.radius(color: .white, borderWidth: 4)
        viewProfileImageBackGround.setShadow(radius: viewProfileImageBackGround.frame.height / 2)

        stackViewSocialLogin.isHidden = true
        viewTextFieldNameMainBackGround.isHidden = true
        viewTextFieldEmailMainBackGround.isHidden = true
        viewTextFieldPhoneNumberMainBackGround.isHidden = true
        viewLabelNameBackGround.radius(radius: 6)
        viewTextFieldNameBackGround.radius(radius: 6)
        viewLabelEmailBackGround.radius(radius: 6)
        viewTextFieldEmailBackGround.radius(radius: 6)
        viewTextFieldPhoneNumberbackGround.radius(radius: 6)
        viewLabelPhoneNumberbackGround.radius(radius: 6)
        viewFaceBookBackGround.radius(radius: 6)
        viewAppleBackGround.radius(radius: 6)
        viewSwitchOfferBackGround.radius(radius: 6)
        viewSwitchEventsBackGround.radius(radius: 6)
        
        viewButtonEditBackGround.radius(radius: 8, color: .lightGray, borderWidth: 1)

        imageViewProfile.circle()
        setData()
        getBlobToken()
    }
    @IBAction func buttonEditProfilePhoto(_ sender: Any) {
        if modelGetBlobToken == nil {
            getBlobToken()
        }
        
        ImagePickerManager().pickImage(self){ image in
                //here is the image
            self.imageViewProfile.image = image
            if let imageData = image.jpegData(compressionQuality: 0.75) {
                //                let fileData = imageData
                let token = self.modelGetBlobToken?.uri ?? ""
                self.uploadImageToBlobStorage(token: token, image: image)
            }
        }
    }
    
    @IBAction func switchOffers(_ sender: Any) {
        updateProfile(isSubscribedToHalalOffersNotification: switchOffers.isOn)
    }
    @IBAction func switchHalalEvents(_ sender: Any) {
        updateProfile(isSubscribedToHalalEventsNewsletter: switchHalalEvents.isOn)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }

    @IBAction func buttonDeleteMyAccount(_ sender: Any) {
        navigateToProfileDeleteViewController()
    }
    
    @IBAction func buttonEditName(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditNameViewController") as! EditNameViewController
        vc.editProfileResponseHandler = {
            self.setData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonEditEmail(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditEmailPhoneViewController") as! EditEmailPhoneViewController
        vc.isFromEmail = true
        vc.editProfileResponseHandler = {
            self.setData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonEditPhoneNumber(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditEmailPhoneViewController") as! EditEmailPhoneViewController
        vc.editProfileResponseHandler = {
            self.setData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setData() {
        labelName.text = "\(kModelGetUserProfileResponse?.firstName ?? "") \(kModelGetUserProfileResponse?.lastName ?? "")"
        textFieldName.text = "\(kModelGetUserProfileResponse?.firstName ?? "") \(kModelGetUserProfileResponse?.lastName ?? "")"
        
        labelEmail.text = kModelGetUserProfileResponse?.email
        textFieldEmail.text = kModelGetUserProfileResponse?.email
        
        labelPhone.text = kModelGetUserProfileResponse?.phone
        textFieldPhone.text = kModelGetUserProfileResponse?.phone
        imageViewProfile.setImage(urlString: kModelGetUserProfileResponse?.profilePictureWebUrl ?? "", placeHolderIcon: "placeHolderUser")
        switchOffers.isOn = kModelGetUserProfileResponse?.isSubscribedToHalalOffersNotification ?? false
        switchHalalEvents.isOn = kModelGetUserProfileResponse?.isSubscribedToHalalEventsNewsletter ?? false
    }
    
    func removeCacheData() {
        kAccessToken = ""
        let dictionary = kDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            kDefaults.removeObject(forKey: key)
        }
        kDefaults.synchronize()
    }
    
    func navigateToProfileDeleteViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileDeleteViewController") as! ProfileDeleteViewController
        
        vc.stringTitle = "Delete my account"
        vc.stringSubTitle = "Are you sure you want to delete your account? "
        vc.stringDescription = "This will permanently remove your personal data, preferences, and reviews."
        vc.stringButtonDelete = "YES, DELETE MY ACCOUNT"
        vc.stringButtonCancel = "CANCEL"
        vc.buttonDeleteHandler = {
            print("delete button press")
            self.deleteuser()
        }
        self.present(vc, animated: true)
    }
    
    func deleteuser() {
        APIs.postAPI(apiName: .mySelf, methodType: .delete, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelGetDeleteUserResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 && responseData == nil {
                self.modelGetDeleteUserResponse =             ModelGetDeleteUserResponse(success: true, message: nil, recordFound: nil, innerExceptionMessage: nil)
            }
            else {
                self.modelGetDeleteUserResponse = model
            }
        }
    }

    func navigateToRootViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.login.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationLoginViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
    
    func getuser() {
        APIs.postAPI(apiName: .mySelf, methodType: .get, encoding: JSONEncoding.default) { responseData, success, errorMsg, statusCode in
            print(responseData ?? "")
            print(success)
            let model: HomeViewController.ModelGetUserProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
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
    
//    func openGallary() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.allowsEditing = false //If you want edit option set "true"
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        self.present(imagePickerController, animated: true, completion: nil)
//    }
    
//    //Mark:- Choose Image Method
//    func funcMyActionSheet() {
//        var myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        myActionSheet.view.tintColor = UIColor.black
//        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.openGallary()
//        })
//        let documentAction = UIAlertAction(title: "Documents", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.openDocumentPicker()
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//        })
//        
//        
//        if IPAD {
//            //In iPad Change Rect to position Popover
//            myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
//        }
//        myActionSheet.addAction(galleryAction)
////        myActionSheet.addAction(documentAction)
//        myActionSheet.addAction(cancelAction)
//        print("Action Sheet call")
//        self.present(myActionSheet, animated: true, completion: nil)
//    }
    
    func getBlobToken() {
        APIs.getAPI(apiName: .getBlobTokenForMosque, parameters: nil, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelGetBlobToken? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBlobToken = model
        }
    }
}

extension ProfileViewController {
    struct ModelGetDeleteUserResponse: Codable {
        let success: Bool?
        let message: String?
        let recordFound: Bool?
        let innerExceptionMessage: String?
    }
}

///Blob Upload Storage
extension ProfileViewController {
    
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
                        self.updateProfile(imageUrl: "\(imageURL)")
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
    
    func updateProfile2(
        imageUrl: URL? = nil,
        isSubscribedToHalalOffersNotification: Bool? = nil,
        isSubscribedToHalalEventsNewsletter: Bool? = nil
    ) {
        let parameters: Parameters = [
            "firstname": kModelGetUserProfileResponse?.firstName ?? "",
            "lastName": kModelGetUserProfileResponse?.lastName ?? "",
            "email": kModelGetUserProfileResponse?.email ?? "",
            "phone": kModelGetUserProfileResponse?.phone ?? "",
            "profilePictureWebUrl": imageUrl == nil ? kModelGetUserProfileResponse?.profilePictureWebUrl ?? "" : imageUrl ?? "",
            "isSubscribedToHalalOffersNotification": isSubscribedToHalalOffersNotification == nil ? kModelGetUserProfileResponse?.isSubscribedToHalalEventsNewsletter ?? "" : isSubscribedToHalalOffersNotification!,
            "isSubscribedToHalalEventsNewsletter":
                isSubscribedToHalalEventsNewsletter == nil ?
            kModelGetUserProfileResponse?.isSubscribedToHalalOffersNotification ?? "" :
                isSubscribedToHalalEventsNewsletter!
        ]
        
        APIs.postAPI(apiName: .updateUser, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: EditNameViewController.ModelEditProfileResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelEditProfileResponse = model
            self.getuser()
        }
    }
    
    func updateProfile(
        imageUrl: String? = nil,
        isSubscribedToHalalOffersNotification: Bool? = nil,
        isSubscribedToHalalEventsNewsletter: Bool? = nil
    ) {
        let parameters: Parameters = [
            "firstname": kModelGetUserProfileResponse?.firstName ?? "",
            "lastName": kModelGetUserProfileResponse?.lastName ?? "",
            "email": kModelGetUserProfileResponse?.email ?? "",
            "phone": kModelGetUserProfileResponse?.phone ?? "",
            "profilePictureWebUrl": imageUrl == nil ? kModelGetUserProfileResponse?.profilePictureWebUrl ?? "" : imageUrl ?? "",
            "isSubscribedToHalalOffersNotification": isSubscribedToHalalOffersNotification == nil ? kModelGetUserProfileResponse?.isSubscribedToHalalOffersNotification ?? "" : isSubscribedToHalalOffersNotification!,
            "isSubscribedToHalalEventsNewsletter":
                isSubscribedToHalalEventsNewsletter == nil ?
            kModelGetUserProfileResponse?.isSubscribedToHalalEventsNewsletter ?? "" :
                isSubscribedToHalalEventsNewsletter!
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

//extension ProfileViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
//    //Image Picker
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageViewProfile.image = image
//            if let imageData = image.jpegData(compressionQuality: 0.75) {
//                //                let fileData = imageData
//                let token = modelGetBlobContainer?.token ?? ""
//                uploadImageToBlobStorage(token: token, image: image)
//            }
//            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//                //                let fileName = imageUrl.lastPathComponent
//            }
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}

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
    // Function to construct the URL of the image in Azure Blob Storage
    func getImageURL(containerURL: String, blobName: String) -> URL? {
        // Construct the base URL
        let urlString = "\(containerURL)/\(blobName)"
        return URL(string: urlString)
    }
}
