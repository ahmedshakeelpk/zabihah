//
//  MyFavouritesViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/08/2024.
//

import Foundation

extension MyFavouritesViewController {
    // MARK: - ModelGetUserAddressResponse
    struct ModelDeleteUserAddressResponse: Codable {
        let title: String?
        let success: Bool?
        let message: String?
        let recordFound: Bool?
        let innerExceptionMessage: String?
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

    // MARK: - ModelAddUserAddressResponse
    struct ModelAddUserAddressResponse: Codable {
        let success: Bool?
        let message: String?
        let recordFound: Bool?
        let innerExceptionMessage: String?
    }
    
    
    // MARK: - ModelGetFavouriteByUserResponse
    struct ModelGetFavouriteResponse: Codable {
        let currentPage, pageSize, totalRecords, totalPages: Int?
        let onFirstPage, onLastPage, hasNextPage, hasPreviousPage: Bool?
        var items: [HomeViewController.ModelRestuarantResponseData?]?
    }
    // MARK: - Item
    struct ModelGetFavouriteResponseData: Codable {
        let id, createdBy, createdOn, updatedBy: String
        let updatedOn: String
        let isDeleted: Bool
        let place: Place
    }

    // MARK: - Place
    struct Place: Codable {
        let id, name, address, iconImageWebURL: String

        enum CodingKeys: String, CodingKey {
            case id, name, address
            case iconImageWebURL = "iconImageWebUrl"
        }
    }
}
