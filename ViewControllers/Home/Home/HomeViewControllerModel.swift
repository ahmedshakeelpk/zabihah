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
        var phone: String?
        let isNewsLetterSubcription: Bool?
        var firstname, email: String?
        let isUpdateSubcription: Bool?
        let photo: String?
        var lastName: String?
    }

    // MARK: - ModelGetHomeRestaurantsResponse
    struct ModelGetHomeRestaurantsResponse: Codable {
        let restuarantResponseData: [ModelRestuarantResponseData]?
        let totalCountHalal: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let featuredRestuarantResponseData: [ModelRestuarantResponseData]?
        let cuisine: [ModelCuisine]?
        let recordFound: Bool?
    }

    // MARK: - Cuisine
    struct ModelCuisine: Codable {
        let name, image: String?
    }

    // MARK: - RestuarantResponseDatum
    struct ModelRestuarantResponseData: Codable {
        let rating: Double?
        let coverImage: String?
        let phone: String?
        let isDelivery: Bool?
        let distanceUnit: DistanceUnit?
        let createdOn: String?
        let iconImage: String?
        let visits: Int?
        let tags: String?
        let gallaryCount: Int?
        let address: String?
        let reviews: Int?
        let distance: Double?
        let name: String?
        let status: Status?
    }

    enum DistanceUnit: String, Codable {
        case m = "m"
        case mi = "mi"
    }

    enum Status: String, Codable {
        case close = "Close"
        case empty = ""
        case statusOpen = "Open"
    }
    
//    **********************
    
    // MARK: - ModelGetHalalRestaurantResponse
    struct ModelGetHalalRestaurantResponse: Codable {
        var halalRestuarantResponseData: [ModelRestuarantResponseData]?
        let totalCountHalal, totalPages: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let cuisine: [ModelCuisine]?
        let recordFound: Bool?
    }

}
