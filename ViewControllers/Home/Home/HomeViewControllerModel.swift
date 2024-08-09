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
        var isNewsLetterSubcription: Bool?
        var firstname, email: String?
        var isUpdateSubcription: Bool?
        let photo: String?
        var lastName: String?
    }

    // MARK: - ModelGetHomeRestaurantsResponse
    struct ModelGetHomeRestaurantsResponse: Codable {
        var restuarantResponseData: [ModelRestuarantResponseData]?
        let totalCountHalal, totalPages, totalPrayerSpaces: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        var featuredRestuarantResponseData: [ModelRestuarantResponseData]?
        let cuisine: [ModelCuisine]?
        let recordFound: Bool?
        let token: String?
        var mosqueResponseData: [ModelRestuarantResponseData]?
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
        let totalCountHalal, totalPages, totalPrayerSpaces: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let cuisine: [ModelCuisine]?
        let recordFound: Bool?
    }

    
    // MARK: - ModelGetPrayerPlacesResponse
    struct ModelGetPrayerPlacesResponse: Codable {
        let totalMosque: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        var mosqueResponseData: [ModelGetPrayerPlacesResponseData]?
        var mosqueTypes: [ModelCuisine]?
        let totalPage: Int?
        let recordFound: Bool?
    }

    // MARK: - MosqueResponseDatum
    struct ModelGetPrayerPlacesResponseData: Codable {
        let iconImage: String?
        let status: String?
        let tags, createdOn, visits: String?
        var isFavorites: Bool?
        let name: String?
        let reviews: Int?
        let long: Double?
        let id: String?
        let coverImage: String?
        let titleImage: String?
        let phone: String?
        let distance: Double?
        let isDelivery: Bool??
        let distanceUnit: String?
        let lat, rating: Double?
        let address: String?
        let gallaryCount: Int?
    }
    // MARK: - MosqueResponseDatum
    struct ModelUserConfigurationResponse: Codable {
        let token: String?
        
    }
}
