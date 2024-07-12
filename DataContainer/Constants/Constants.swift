//
//  Constants.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 10/07/2024.
//

import Foundation
import UIKit

let GOOGLE_API_KEY = "AIzaSyBk8U2DYsEn3sWykNHXBL8A8ORjCiaLeRA"
var kAccessToken = ""
let IPAD = UIDevice.current.userInterfaceIdiom == .pad



let accountNameForStorage = "zabihahblob"
let containerName = "profileimage"
var sasToken = ""

var modelGetUserResponse: HomeViewController.ModelGetUserResponse? {
    didSet {
        
    }
}
