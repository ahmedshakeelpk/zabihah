//
//  FPNTextFieldExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 18/07/2024.
//

import Foundation
import FlagPhoneNumber

extension FPNTextField {
    func getCompletePhoneNumber() -> String {
        let countryCode = (self.selectedCountry?.phoneCode)!
        let phoneNumber = self.text!.replacingOccurrences(of: " ", with: "")
        let completePhoneNumber = "\(countryCode)\(phoneNumber)"
        return completePhoneNumber
    }
}
