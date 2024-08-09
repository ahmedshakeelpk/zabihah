//
//  Constants.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 10/07/2024.
//

import Foundation
import UIKit
import CoreLocation

let GOOGLE_API_KEY = "AIzaSyBk8U2DYsEn3sWykNHXBL8A8ORjCiaLeRA"
//let GOOGLE_API_KEY = ""
var kAccessToken = ""
var kUserCurrentLocation: CLLocation!
var kModelUserConfigurationResponse: LoginViewController.ModelUserConfigurationResponse!
let IPAD = UIDevice.current.userInterfaceIdiom == .pad
let kDefaults = UserDefaults.standard



let accountNameForStorage = "zabihahblob"
let containerName = "profileimage"
var sasToken = ""

var modelGetUserProfileResponse: HomeViewController.ModelGetUserProfileResponse? {
    didSet {
        NotificationCenter.default.post(name: Notification.Name("kUserProfileUpdate"), object: nil)
    }
}
