//
//  AddAddressFieldsViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 15/07/2024.
//

import Foundation

extension AddAddressViewController {
    // MARK: - ModelEditUserAddress
    struct ModelEditUserAddressResponse: Codable {
        let success: Bool?
        let message: String?
        let recordNotFound: Bool?
        let innerExceptionMessage: String?
        let modelUserAddressResponseData: ModelUserAddressResponseData?
    }

    // MARK: - UserAddressResponseData
    struct ModelUserAddressResponseData: Codable {
        let id: String?
        let utmCoordinates: Double?
        let createdOn: Date?
        let longitude: Double?
        let isDefault: Bool?
        let latitude: Double?
        let title, userID, address, createdBy: String?
        let isDeleted: Bool?
        let deliveryInstructions, name, locationInstruction: String?

        enum CodingKeys: String, CodingKey {
            case id, utmCoordinates, createdOn, longitude, isDefault, latitude, title
            case userID = "userId"
            case address, createdBy, isDeleted, deliveryInstructions, name, locationInstruction
        }
    }
}
