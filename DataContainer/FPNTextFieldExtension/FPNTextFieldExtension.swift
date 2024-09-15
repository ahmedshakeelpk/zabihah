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
        var phoneNumber = self.text!.replacingOccurrences(of: " ", with: "")
        phoneNumber = phoneNumber.getIntegerValue()
        let completePhoneNumber = "\(countryCode)\(phoneNumber)"
        return completePhoneNumber
    }
}

