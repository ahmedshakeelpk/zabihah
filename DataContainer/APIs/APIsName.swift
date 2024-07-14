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
        case getblobcontainer = "api/Blob/getblobcontainer"
        
        //MARK:- V1
        case usersignup = "v1/User/usersignup"
        case getuser = "v1/User/getuser"
        case deleteuser = "v1/User/deleteuser"
        case editprofile = "v1/User/editprofile"
        
        
        
    }
}

