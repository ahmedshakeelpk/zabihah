//
//  OtpLoginViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation

extension OtpLoginViewController {
    // MARK: - ModelOtpResponse
    struct ModelOtpResponse: Codable {
//        let success: Bool?
        let title: String?
        let message: String?
//        let userResponseData: ModelOtpResponseData?
//        let recordFound: Bool?
//        let innerExceptionMessage: String?
        let token: String?
        let refreshToken: String?
    }
    
    // MARK: - ModelOtpResponseData
    struct ModelOtpResponseData: Codable {
//        let phone: String?
//        let isNewsLetterSubcription: Bool?
//        let firstname, email: String?
//        let isUpdateSubcription: Bool?
//        let photo: String?
//        let lastName: String?
        let token: String?
        let refreshToken: String?
    }
}
