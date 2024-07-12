//
//  HomeViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/07/2024.
//

import Foundation

extension HomeViewController {
    // MARK: - ModelGetUserResponse
    struct ModelGetUserResponse: Codable {
        let success: Bool
        let message: String
        let userResponseData: ModelGetUserResponseData
        let recordNotFound: Bool
        let innerExceptionMessage, token: String
    }

    // MARK: - UserResponseData
    struct ModelGetUserResponseData: Codable {
        let phone: String
        let isNewsLetterSubcription: Bool
        let firstname, email: String
        let isUpdateSubcription: Bool
        let photo: String
        let lastName: String
    }
}
