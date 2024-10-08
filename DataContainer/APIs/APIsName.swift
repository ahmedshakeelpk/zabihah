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
        
        //MARK:- Restaurant
        case gethomerestaurants = "api/Restaurant/gethomerestaurants"
        case gethalalrestaurants = "api/Restaurant/gethalalrestaurants"
        case getrestaurantdetail = "api/Restaurant/getrestaurantdetail"
        
        
        //MARK:- Mosque
        case getprayerplaces = "api/Mosque/getprayerplaces"
        
        
        
        //MARK:- Favorite
        case postfavouriterestaurants = "api/Favorite/postfavouriterestaurants"
        case getfavouritebyuser = "api/Favorite/getfavouritebyuser"
        
        //MARK:- Config
        case userConfiguration = "api/Config/userConfiguration"

        
        
        //MARK:- V1
        case usersignup = "v1/User/usersignup"
        case getuser = "v1/User/getuser"
        case deleteuser = "v1/User/deleteuser"
        case editprofile = "v1/User/editprofile"
        case getuseraddress = "v1/User/getuseraddress"
        case adduseraddress = "v1/User/adduseraddress"
        case edituseraddress = "v1/User/edituseraddress"
        case deleteuseraddress = "v1/User/deleteuseraddress"
        
        //MARK:- Faq
        case getfaq = "api/Faq/getfaq"
        
        //MARK:- Blob
        case AddImageUrlsToPhoto = "api/Blob/AddImageUrlsToPhoto"
        
        //MARK:- Review
        case postreview = "api/Review/postreview"
        case editreview = "api/Review/editreview"
        case getbytype = "api/Review/getbytype"
        case getbyuser = "api/Review/getbyuser"
        case deletereview = "api/Review/deletereview"
        

        
        
    }
}

