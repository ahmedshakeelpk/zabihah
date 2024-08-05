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
    @IBOutlet weak var switchEvents: UISwitch!{
        didSet{
            switchEvents.onTintColor = .colorApp
        }
    }
    @IBOutlet weak var viewTextFieldNameMainBackGround: UIView!
    @IBOutlet weak var viewTextFieldEmailMainBackGround: UIView!
    @IBOutlet weak var viewTextFieldPhoneNumberMainBackGround: UIView!
    
    var modelGetBlobContainer: RegisterationViewController.ModelGetBlobContainer? {
        didSet {
            print(modelGetBlobContainer?.token as Any)
        }
    }
    
    var modelEditProfileResponse: EditNameViewController.ModelEditProfileResponse? {
        didSet {
            getuser()
        }
    }
    
    var modelGetDeleteUserResponse: ModelGetDeleteUserResponse? {
        didSet {
            if modelGetDeleteUserResponse?.success ?? false {
                self.showAlertCustomPopup(title: "Success", message: self.modelGetDeleteUserResponse?.message ?? "", iconName: .iconSuccess) { _ in
                    self.navigateToRootViewController()
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelGetDeleteUserResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    var modelGetUserResponseLocal: HomeViewController.ModelGetUserProfileResponse? {
        didSet {
            modelGetUserProfileResponse = modelGetUserResponseLocal
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackViewSocialLogin.isHidden = true
        viewTextFieldNameMainBackGround.isHidden = true
        viewTextFieldEmailMainBackGround.isHidden = true
        viewTextFieldPhoneNumberMainBackGround.isHidden = true
        setData()
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
        getblobcontainer()
    }
    @IBAction func buttonEditProfilePhoto(_ sender: Any) {
        if modelGetBlobContainer == nil {
            getblobcontainer()
        }
        funcMyActionSheet()
    }
    
    @IBAction func switchOffers(_ sender: Any) {
        let parameters: Parameters = [
            "isUpdateSubcription": switchOffers.isOn,
            "isNewsLetterSubcription": switchEvents.isOn
        ]
        editprofile(parameters: parameters)
    }
    @IBAction func switchEvents(_ sender: Any) {
        let parameters: Parameters = [
            "isUpdateSubcription": switchOffers.isOn,
            "isNewsLetterSubcription": switchEvents.isOn
        ]
        editprofile(parameters: parameters)
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
        labelName.text = "\(modelGetUserProfileResponse?.userResponseData?.firstname ?? "") \(modelGetUserProfileResponse?.userResponseData?.lastName ?? "")"
        textFieldName.text = "\(modelGetUserProfileResponse?.userResponseData?.firstname ?? "") \(modelGetUserProfileResponse?.userResponseData?.lastName ?? "")"
        
        labelEmail.text = modelGetUserProfileResponse?.userResponseData?.email
        textFieldEmail.text = modelGetUserProfileResponse?.userResponseData?.email
        
        labelPhone.text = modelGetUserProfileResponse?.userResponseData?.phone
        textFieldPhone.text = modelGetUserProfileResponse?.userResponseData?.phone
        imageViewProfile.setImage(urlString: modelGetUserProfileResponse?.userResponseData?.photo ?? "", placeHolderIcon: "placeHolderUser")
        switchOffers.isOn = modelGetUserProfileResponse?.userResponseData?.isUpdateSubcription ?? false
        switchEvents.isOn = modelGetUserProfileResponse?.userResponseData?.isNewsLetterSubcription ?? false
    }
    
    func navigateToProfileDeleteViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileDeleteViewController") as! ProfileDeleteViewController
        vc.buttonDeleteHandler = {
            print("delete button press")
            self.deleteuser()
        }
        self.present(vc, animated: true)
    }
  
    func deleteuser() {
        APIs.postAPI(apiName: .deleteuser, methodType: .delete, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetDeleteUserResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetDeleteUserResponse = model
        }
    }

    func navigateToRootViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.login.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationLoginViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
    
    func getuser() {
        APIs.postAPI(apiName: .getuser, methodType: .get, encoding: URLEncoding.default) { responseData, success, errorMsg in
            print(responseData ?? "")
            print(success)
            let model: HomeViewController.ModelGetUserProfileResponse? = APIs.decodeDataToObject(data: responseData)
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
            let model: RegisterationViewController.ModelGetBlobContainer? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBlobContainer = model
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
    
    func openGallary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //Mark:- Choose Image Method
    func funcMyActionSheet() {
        var myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        myActionSheet.view.tintColor = UIColor.black
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let documentAction = UIAlertAction(title: "Documents", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openDocumentPicker()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        if IPAD {
            //In iPad Change Rect to position Popover
            myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        }
        myActionSheet.addAction(galleryAction)
//        myActionSheet.addAction(documentAction)
        myActionSheet.addAction(cancelAction)
        print("Action Sheet call")
        self.present(myActionSheet, animated: true, completion: nil)
    }
            
    func editprofile(parameters: Parameters) {
        
        APIs.postAPI(apiName: .editprofile, parameters: parameters, methodType: .post, viewController: self) { responseData, success, errorMsg in
            let model: EditNameViewController.ModelEditProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelEditProfileResponse = model
        }
    }
}

extension ProfileViewController {
    struct ModelGetDeleteUserResponse: Codable {
        let success: Bool
        let message: String
        let recordFound: Bool
        let innerExceptionMessage: String
    }
}

///Blob Upload Storage
extension ProfileViewController {
    
    func uploadImageToBlobStorage(token: String, image: UIImage) {
        //        let containerURL = "https://zabihahblob.blob.core.windows.net/profileimage"//containerName
        let currentDate1 = Date()
        let blobName = String(currentDate1.timeIntervalSinceReferenceDate)+".jpg"
        
        let tempToken = token.components(separatedBy: "?")
        
        let sasToken = tempToken.last ?? ""
        let containerURL = "\(tempToken.first ?? "")"
        print("containerURL with SAS: \(containerURL) ")
        
        let azureBlobStorage = AzureBlobStorage(containerURL: containerURL, sasToken: sasToken)
        azureBlobStorage.uploadImage(image: image, blobName: blobName) { success, error in
            if success {
                print("Image uploaded successfully!")
                if let imageURL = azureBlobStorage.getImageURL(storageAccountName: "zabihahblob", containerName: containerName, blobName: blobName, sasToken: "") {
                    print("Image URL: \(imageURL)")
                    DispatchQueue.main.async {
                        let parameters: Parameters = [
                            "photo": "\(imageURL)"
                        ]
                        self.editprofile(parameters: parameters)
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

extension ProfileViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //Document
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let filename = urls.first?.lastPathComponent {
            do {
                for url in urls {
                    let fileData = try Data(contentsOf: url)
                }
            } catch {
                print("no data")
            }
        }
        
        // display picked file in a view
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    //Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageViewProfile.image = image
            if let imageData = image.jpegData(compressionQuality: 0.75) {
                //                let fileData = imageData
                let token = modelGetBlobContainer?.token ?? ""
                uploadImageToBlobStorage(token: token, image: image)
            }
            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                //                let fileName = imageUrl.lastPathComponent
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
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
