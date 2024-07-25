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
    
    // MARK: - ModelGetFeaturedRestaurants
    struct ModelGetFeaturedRestaurantsResponse: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let featuredRestuarantResponseData: [FeaturedRestuarantResponseDatum]?
    }

    // MARK: - FeaturedRestuarantResponseDatum
    struct FeaturedRestuarantResponseDatum: Codable {
        let address, phone: String?
        let rating, distance: Double?
        let gallaryCount, reviews: Int?
        let iconImage: String?
        let isDelivery: Bool?
        let name: String?
        let tags: String?
        let visits: Int??
    }
}
