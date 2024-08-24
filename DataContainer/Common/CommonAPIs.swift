//
//  CommonAPIs.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 01/08/2024.
//

import Foundation
import UIKit

class CommonAPIs {
    
    func getUserAddress<T: Codable>(viewController: UIViewController, ModelResponse: T?, completion: @escaping(_ response: T) -> Void) {
        APIs.postAPI(apiName: .getuseraddress, methodType: .get, viewController: viewController) { responseData, success, errorMsg in
            let model: T? = APIs.decodeDataToObject(data: responseData)
            
//            let model: AddressesListViewController.ModelGetUserAddressResponse?
//            self.modelGetUserAddressResponse = model
            completion(model!)
        }
    }
}
