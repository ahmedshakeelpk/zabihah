//
//  OtpLoginViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation

extension OtpLoginViewController {
    // MARK: - ModelGenericResponse
    struct ModelOtpResponse: Codable {
        let recordNotFound, success: Bool
        let message, innerExceptionMessage: String?
    }
}
