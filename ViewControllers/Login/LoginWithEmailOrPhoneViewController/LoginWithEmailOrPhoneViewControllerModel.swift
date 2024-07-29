//
//  LoginWithEmailOrPhoneViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation

extension LoginWithEmailOrPhoneViewController {
    // MARK: - ModelGenericResponse
    struct ModelSendnotificationResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
    }
}
