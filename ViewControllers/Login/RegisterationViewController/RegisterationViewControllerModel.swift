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
        let success: Bool?
        let message: String?
        let userResponseData: UserResponseData?
        let recordFound: Bool?
        let innerExceptionMessage, token: String?
    }

    // MARK: - UserResponseData
    struct UserResponseData: Codable {
        let phone: String?
        let isNewsLetterSubcription: Bool?
        let firstname, email: String?
        let isUpdateSubcription: Bool?
        let photo: String?
        let lastName: String?
    }
    
    struct ModelGetBlobContainer: Codable {
        let token: String
        let containerName, storageAccountURL: String
    }
}
