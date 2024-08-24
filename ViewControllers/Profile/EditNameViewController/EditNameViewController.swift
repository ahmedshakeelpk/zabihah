//
//  EditNameViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/07/2024.
//

import UIKit
import Alamofire

class EditNameViewController: UIViewController {
    @IBOutlet weak var viewBackGroundButtonSave: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    
    var editProfileResponseHandler: (() -> ())!
    var modelEditProfileResponse: ModelEditProfileResponse? {
        didSet {
            if modelEditProfileResponse?.success ?? false {
                modelGetUserProfileResponse?.userResponseData?.firstname = self.modelEditProfileResponse?.userResponseData?.firstname
                modelGetUserProfileResponse?.userResponseData?.lastName = self.modelEditProfileResponse?.userResponseData?.lastName
                self.editProfileResponseHandler?()
                self.popViewController(animated: true)
                
//                self.showAlertCustomPopup(title: "Success", message: self.modelEditProfileResponse?.message ?? "", iconName: .iconSuccess) { _ in
//                    modelGetUserProfileResponse?.userResponseData?.firstname = self.modelEditProfileResponse?.userResponseData?.firstname
//                    modelGetUserProfileResponse?.userResponseData?.lastName = self.modelEditProfileResponse?.userResponseData?.lastName
//                    self.editProfileResponseHandler?()
//                    self.popViewController(animated: true)
//                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelEditProfileResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundButtonSave.radius(radius: 8)
        setData()
        setConfiguration()
    }
    func setData() {
        textFieldFirstName.text = modelGetUserProfileResponse?.userResponseData?.firstname
        textFieldLastName.text = modelGetUserProfileResponse?.userResponseData?.lastName
    }
    
    func setConfiguration() {
        textFieldFirstName.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        textFieldLastName.addTarget(self, action: #selector(fieldVilidation), for: .editingChanged)
        
        fieldVilidation()
    }
    @objc func fieldVilidation() {
        var isValid = true
        if textFieldFirstName.text == "" {
            isValid = false
        }
        else if textFieldLastName.text == "" {
            isValid = false
        }
        buttonSave.isEnabled = isValid
        viewBackGroundButtonSave.backgroundColor = isValid ? .clrLightBlue : .clrDisableButton
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }

    @IBAction func buttonSave(_ sender: Any) {
        if textFieldFirstName.text == "" {
            self.showToast(message: "Enter first name!")
        }
        else if textFieldLastName.text == "" {
            self.showToast(message: "Enter last name!")
        }
        else {
            editprofile()
        }
    }
    
    func editprofile() {
        let parameters: Parameters = [
            "firstname": textFieldFirstName.text!,
            "lastName": textFieldLastName.text!,
//              "email": "string",
//              "phone": "string",
//              "photo": "string",
//              "isUpdateSubcription": true,
//              "isNewsLetterSubcription": true
        ]
        APIs.postAPI(apiName: .editprofile, parameters: parameters, methodType: .post, viewController: self) { responseData, success, errorMsg in
            let model: ModelEditProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelEditProfileResponse = model
        }
    }
}

extension EditNameViewController {
    // MARK: - ModelEditProfileResponse
    struct ModelEditProfileResponse: Codable {
        let success: Bool?
        let message: String?
        let recordFound: Bool?
        let innerExceptionMessage: String?
        let userResponseData: ModelEditProfileResponseData?
    }

    // MARK: - UserResponseData
    struct ModelEditProfileResponseData: Codable {
        let lastName: String?
        let isUpdateSubcription, isNewsLetterSubcription: Bool?
        let photo, firstname: String?
    }
}
