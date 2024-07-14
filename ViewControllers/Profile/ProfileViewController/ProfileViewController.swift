//
//  ProfileViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/07/2024.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var textFieldPhone: UITextField!
    
    
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
            switchOffers.onTintColor = .clrApp
        }
    }
    @IBOutlet weak var switchEvents: UISwitch!{
        didSet{
            switchEvents.onTintColor = .clrApp
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    @IBAction func switchOffers(_ sender: Any) {
    }
    @IBAction func switchEvents(_ sender: Any) {
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonEditPhoneNumber(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditEmailPhoneViewController") as! EditEmailPhoneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setData() {
        labelName.text = "\(modelGetUserResponse?.userResponseData?.firstname ?? "") \(modelGetUserResponse?.userResponseData?.lastName ?? "")"
        textFieldName.text = "\(modelGetUserResponse?.userResponseData?.firstname ?? "") \(modelGetUserResponse?.userResponseData?.lastName ?? "")"
        
        labelEmail.text = modelGetUserResponse?.userResponseData?.email
        textFieldEmail.text = modelGetUserResponse?.userResponseData?.email
        
        labelPhone.text = modelGetUserResponse?.userResponseData?.phone
        textFieldPhone.text = modelGetUserResponse?.userResponseData?.phone
        
//        stackViewName.isHidden = buttonEditName.tag == 0
//        stackViewEmail.isHidden = buttonEditEmail.tag == 0
//        stackViewPhone.isHidden = buttonEditPhoneNumber.tag == 0
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
    
    
    func navigateToRootViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.login.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationLoginViewController") as? UINavigationController {
            self.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
}

extension ProfileViewController {
    struct ModelGetDeleteUserResponse: Codable {
        let success: Bool
        let message: String
        let recordNotFound: Bool
        let innerExceptionMessage: String
    }
}
