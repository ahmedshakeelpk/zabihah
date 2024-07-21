//
//  HomeViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/07/2024.
//

import Foundation

extension HomeViewController {
    // MARK: - ModelGetUserResponse
    struct ModelGetUserProfileResponse: Codable {
        let success: Bool?
        let message: String?
        var userResponseData: ModelGetUserResponseData?
        let recordFound: Bool?
        let innerExceptionMessage, token: String?
    }

    // MARK: - UserResponseData
    struct ModelGetUserResponseData: Codable {
        let phone: String?
        let isNewsLetterSubcription: Bool?
        var firstname, email: String?
        let isUpdateSubcription: Bool?
        let photo: String?
        var lastName: String?
    }
}
