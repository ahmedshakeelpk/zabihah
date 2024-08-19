//
//  DeliveryDetailsViewController3Model.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 16/08/2024.
//


extension DeliveryDetailsViewController3 {
    // MARK: - ModelGetRestaurantDetailResponse
    struct ModelGetRestaurantDetailResponse: Codable {
        var restuarantResponseData: RestuarantResponseData?
        let social: [Social]?
        let timing: [Timing]?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        let amenities: [Amenities]?
        let recordFound: Bool?
    }
    
    // MARK: - RestuarantResponseData
    struct RestuarantResponseData: Codable {
        let id, description: String?
        let shareLink: String?
        let phone, distanceUnit: String?
        let rating: Double?
        let halalDescription: String?
        let iconImage: String?
        let visits: Int?
        let gallery: [String]?
        let isFullHalal, isalcohhol: Bool?
        let status, address: String?
        let reviews: Int?
        let distance: Double?
        let returning: Int?
        var isFavorites: Bool?
        let name: String?
    }

    // MARK: - Social
    struct Social: Codable {
        let title: String?
        let url: String?
    }
    
    // MARK: - Social
    struct Amenities: Codable {
        let title: String?
        let image: String?
    }

    // MARK: - Timing
    struct Timing: Codable {
        let day, openTime, closeTime: String?
    }
    
    // MARK: - ModelAddImageUrlsToPhoto
    struct ModelAddImageUrlsToPhoto: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token, refreshToken, imageData: String?
        let imageUrls: [String]?
    }
}
