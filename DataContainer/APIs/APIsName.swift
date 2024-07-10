//
//  APIsName.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation

struct APIPath {
    //original ur
    public static let  baseUrl = "https://zabihahdev1.centralindia.cloudapp.azure.com/"
    
}
struct APIsName {
    enum name: String {
        //MARK:- API
        case sendnotification = "api/Notification/sendnotification"
        case verifyOtp = "api/Otp/verifyOtp"
        
        
        //MARK:- V1
        case userignup = "v1/User/userignup"
        
        
    }
}

