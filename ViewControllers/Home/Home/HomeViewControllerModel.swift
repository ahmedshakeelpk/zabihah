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
        var featuredRestuarantResponseData: [ModelRestuarantResponseData]?
        let cuisine: [ModelCuisine]?
        let recordFound: Bool?
        let token: String?
        let mosqueResponseData: [ModelRestuarantResponseData]?
    }

    // MARK: - Cuisine
    struct ModelCuisine: Codable {
        let name, image: String?
    }

    // MARK: - RestuarantResponseDatum
    struct ModelRestuarantResponseData: Codable {
        let iconImage: String?
        let status, tags: String?
        let createdOn: String?
        let visits: Int?
        var isFavorites: Bool?
        let name: String?
        let reviews: Int?
        let long: Double?
        let id: String?
        let coverImage: String?
        let titleImage: String?
        let phone: String?
        let distance: Double?
        let isDelivery: Bool?
        let distanceUnit: String?
        let lat, rating: Double?
        let address: String?
        let gallaryCount: Int?
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
