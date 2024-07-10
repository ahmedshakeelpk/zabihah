//
//  RegisterationViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation

extension RegisterationViewController {
    
    struct ModelRegistrationRequest: Codable {
        let firstname, lastName, email, phone: String
        let photo: String
        let isNewsLetter: Bool
    }
    
    struct ModelSignUpResponse: Codable {
        let recordNotFound, success: Bool?
        let message, innerExceptionMessage: String?
    }
}
