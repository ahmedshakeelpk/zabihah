//
//  APIsName.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation

struct APIPath {
    //original ur
    public static let  baseUrl = "https://zabihahdev1.centralindia.cloudapp.azure.com:81/v1/"
    
}
struct APIsName {
    enum name: String {
        //MARK:- API
        case request = "User/otp/request"
        case verifyOtp = "User/otp/verify"
        case mySelf = "User/my"
        case updateUser = "User"
        case edituseraddress = "User/address"
        case search = "Restaurant/search"
        case mosqueSearch = "Mosque/search"
        //MARK:- Config
        case userConfiguration = "Configuration"
        //MARK:- Favorite
//        case favourite = "Favorite/{placeId}"
        case favourite = "Favorite/{placeId}"
        case favouriteDelete = "Favorite/by/place/{placeId}"
        case getFavourite = "Favorite/my"
        //MARK:- Faq
        case faq = "Faq"

        
        
        
        
        
        
        
        case getblobcontainer = "User/profile-picture/generate/sas/upload"
        
        //MARK:- Restaurant
        case gethomerestaurants = "api/Restaurant/gethomerestaurants"
        case gethalalrestaurants = "api/Restaurant/gethalalrestaurants"
        case getrestaurantdetail = "api/Restaurant/getrestaurantdetail"
        
        
        //MARK:- Mosque
        case getprayerplaces = "api/Mosque/getprayerplaces"
        
        
        
        
        

        
        
        //MARK:- V1
        case getuser = "v1/User/getuser"
        case editprofile = "v1/User/editprofile"
        
        
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

