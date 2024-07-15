//
//  AddressesListViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 14/07/2024.
//

import Foundation

// MARK: - ModelGetUserAddressResponse
extension AddressesListViewController {
    // MARK: - ModelGetUserAddressResponse
    struct ModelDeleteUserAddressResponse: Codable {
        let success: Bool?
        let message: String?
        let recordNotFound: Bool?
        let innerExceptionMessage: String?
    }
    
    // MARK: - ModelGetUserAddressResponse
    struct ModelGetUserAddressResponse: Codable {
        let success: Bool?
        let message: String?
        let userAddressesResponseData: [ModelUserAddressesResponseData]?
        let recordNotFound: Bool?
        let innerExceptionMessage: String?
    }

    // MARK: - UserAddressesResponseData
    struct ModelUserAddressesResponseData: Codable {
        let id: String?
        let utmCoordinates: Double?
        let createdOn: String?
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
