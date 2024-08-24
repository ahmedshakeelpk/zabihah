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
    struct ModelGetFavouriteByUserResponse: Codable {
        let halalRestuarantResponseData, prayerSpacesResponseData: [HomeViewController.ModelRestuarantResponseData]?
        let totalPages: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        let totalFavorities: Int?
        let recordFound: Bool?
    }

//    // MARK: - ResponseDatum
//    struct ModelGetFavouriteByUserResponseData: Codable {
//        let iconImage: String?
//        let status, tags: String?
//        let createdOn: String?
//        let visits: Int?
//        let isFavorites: Bool?
//        let name: String?
//        let reviews: Int?
//        let long: Double?
//        let id: String?
//        let coverImage: String?
//        let titleImage: String?
//        let phone: String?
//        let distance: Int?
//        let isDelivery: Bool?
//        let distanceUnit: String?
//        let lat, rating: Double?
//        let address: String?
//        let gallaryCount: Int?
//    }
}
