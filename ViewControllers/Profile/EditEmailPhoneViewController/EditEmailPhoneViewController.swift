//
//  EditEmailPhoneViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import FlagPhoneNumber

class EditEmailPhoneViewController: UIViewController {

    @IBOutlet weak var textFieldPhoneNumber: FPNTextField!
    @IBOutlet weak var buttonSendVerificationCode: UIButton!
    @IBOutlet weak var viewBackGroundButtonSend: UIView!
    @IBOutlet weak var viewBackGroundEmail: UIView!
    @IBOutlet weak var viewBackGroundPhoneNumber: UIView!
    @IBOutlet weak var stackViewPhoneNumber: UIStackView!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var buttonBack: UIButton!

    
    var isFromEmail: Bool = false

    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundButtonSend.radius(radius: 8)
        viewBackGroundEmail.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        viewBackGroundPhoneNumber.radius(radius: 8, color: .clrBorder, borderWidth: 1)
        if isFromEmail {
            stackViewPhoneNumber.isHidden = true
        }
        else {
            stackViewEmail.isHidden = true
            textFieldPhoneNumber.setFlag(countryCode: .US)
            textFieldPhoneNumber.delegate = self
            textFieldPhoneNumber.displayMode = .list // .picker by default
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonSendVerificationCode(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "OtpEmailViewController") as! OtpEmailViewController
        vc.isFromEmail = isFromEmail
        self.navigationController?.pushViewController(vc, animated: true)
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
