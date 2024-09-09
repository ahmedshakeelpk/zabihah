//
//  HomeViewControllerModel.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/07/2024.
//

import Foundation

extension HomeViewController {
    // MARK: - ModelFeaturedRequest
    struct ModelFeaturedRequest: Codable {
        let ids: [String]?
        let rating: Int?
        let page: Int?
        let pageSize: Int?
        let cuisine: [String]?
        let meatHalalStatus: [HalalStatus]?
        let alcoholPolicy: [AlcoholPolicy]?
        let parts: [PlacePart]?
        let orderBy: PlaceOrderBy?
        let sortOrder: SortOrder?
        let location: Location?
    }
    
    // MARK: - Location
    struct Location: Codable {
        let distanceUnit: DistanceUnit
        let latitude, longitude: Double
        let radius: Int
    }
    
    struct ModelFilterRequest: Codable {
        let radius: String?
        let rating: Int?
        let isalcoholic: Bool?
        let isHalal: Bool?
    }
    
    enum PlaceOrderBy: String, Codable {
        case none = "None"
        case rating = "Rating"
        case location = "Location"
        case ratingAndLocation = "RatingAndLocation"
    }
    enum HalalStatus: String, Codable {
        case none = "None"
        case unknown = "Unknown"
        case partial = "Partial"
        case full = "Full"
    }
    enum AlcoholPolicy: String, Codable {
        case none = "None"
        case served = "Served"
        case allowedButNotServed = "AllowedButNotServed"
        case notAllowed = "NotAllowed"
    }
    enum SortOrder: String, Codable {
        case none = "None"
        case ascending = "Ascending"
        case descending = "Descending"
    }
    enum PlacePart: String, Codable {
        case none = "None"
        case webLinks = "WebLinks"
        case amenities = "Amenities"
        case reviews = "Reviews"
        case cuisines = "Cuisines"
        case timings = "Timings"
        case photos = "Photos"
    }
    enum DistanceUnit: String, Codable {
        case none = "None"
        case meters = "Meters"
        case kilometers = "Kilometers"
        case miles = "Miles"
    }
}

extension HomeViewController {
    // MARK: - ModelGetUserResponse
    struct ModelGetUserProfileResponse: Codable {
        var id, lastName, firstName, phone: String?
        var isSubscribedToHalalEventsNewsletter: Bool?
        var addresses: [AddressesListViewController.ModelUserAddressesResponseData]?
        var isEmailVerified: Bool?
        var createdOn, updatedOn: String?
        var isPhoneVerified, isDeleted, isSubscribedToHalalOffersNotification: Bool?
        var createdBy, profilePictureWebUrl, updatedBy, email: String?
    }

//    // MARK: - UserResponseData
//    struct ModelGetUserResponseData: Codable {
//        var id: String?
//        var firstname, email: String?
//        var isSubscribedToHalalEventsNewsletter: Bool?
//        var isSubscribedToHalalOffersNotification: Bool?
//        let profilePictureWebUrl: String?
//        var lastName: String?
//        var phone: String?
//        var isPhoneVerified: Bool?
//        var isDeleted: Bool?
//        var isEmailVerified: Bool?
//        var addresses: [AddressesListViewController.ModelUserAddressesResponseData]?
//        var updatedOn : String?
//        var createdOn : String?
//        var createdBy : String?
//        var updatedBy : String?
//    }

    // MARK: - ModelGetHomeRestaurantsResponse
    struct ModelGetHomeRestaurantsResponse2: Codable {
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

    // MARK: - RestuarantResponseDatum
    struct ModelRestuarantResponseData2: Codable {
        let iconImage: String?
        let status, tags: String?
        let createdOn: String?
        let type: String?
        let visits: Int?
        var isFavorites: Bool?
        let name: String?
        let reviews: Int?
        let longitude: Double?
        let id: String?
        let coverImage: String?
        let titleImage: String?
        let phone: String?
        let distance: Double?
        let isDelivery: Bool?
        let distanceUnit: String?
        let latitude, rating: Double?
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
        var mosqueResponseData: [ModelRestuarantResponseData?]?
        var mosqueTypes: [ModelCuisine]?
        let totalPage: Int?
        let recordFound: Bool?
    }

//    // MARK: - MosqueResponseDatum
//    struct ModelGetPrayerPlacesResponseData: Codable {
//        let iconImage: String?
//        let status: String?
//        let tags, createdOn: String?
//        var isFavorites: Bool?
//        let name: String?
//        let reviews, visits: Int?
//        let long: Double?
//        let id: String?
//        let coverImage: String?
//        let titleImage: String?
//        let phone: String?
//        let distance: Double?
//        let isDelivery: Bool??
//        let distanceUnit: String?
//        let lat, rating: Double?
//        let address: String?
//        let gallaryCount: Int?
//    }
    
    struct ModelUserConfigurationResponse: Codable {
        let distance: ModelUserConfigurationResponseData?
    }

    // MARK: - Distance
    struct ModelUserConfigurationResponseData: Codable {
        let distance: Int?
        let unit: String?
    }
    // MARK: - Place
    struct Place: Codable {
        var id, name, address, iconImageWebURL: String

        enum CodingKeys: String, CodingKey {
            case id, name, address
            case iconImageWebURL = "iconImageWebUrl"
        }
    }
//    // MARK: - ModelGetConfigurationResponse
//    struct ModelUserConfigurationResponse: Codable {
//        let distanceValue: Int?
//        let success: Bool?
//        let message, innerExceptionMessage: String?
//        let token: String?
//        let distanceUnit: String?
//        let recordFound: Bool?
//    }
}




extension HomeViewController {
    // MARK: - ModelFeaturedRequest
    struct ModelFeaturedResponse: Codable {
        let currentPageIndex, pageSize, totalRecords: Int?
        let onFirstPage: Bool?
        let currentPage, totalPages: Int?
        let hasNextPage, onLastPage, hasPreviousPage: Bool?
        var items: [HomeViewController.ModelRestuarantResponseData?]?
    }

    // MARK: - Item
    struct ModelRestuarantResponseData: Codable {
        let halalDescription: String?
        let averageRating: Rating?
        let isDeleted: Bool?
        let zip: String?
        let country: String?
        let timings: [Timing?]?
        let offersDelivery: Bool?
        let region: String?
        let subRegion: String?
        let restaurantType: String?
        let latitude: Double?
        let city, name: String?
        let reviews: [Review?]?
        let type: String?
        let state: String?
        let totalReviews: Int?
        let amenities: [Amenity]?
        var id: String?
        let cuisines: [ModelCuisine?]?
        let webLinks: [WebLink?]?
        let longitude: Double?
        let mobile: String?
        let phone: String?
        let distance: Distance?
        let willReturnPercentage: Rating?
        let approvalState: String?
        let address: String?
        let description: String?
        let alcoholPolicy: String?
        let meatHalalStatus: String?
        
        
        let createdOn: String?
        var isFavorites: Bool?
        var totalPhotos: Int?
        let photos: [Photos?]?
        let photoWebUrls: [String?]?
        var isMyFavorite: Bool?
        let iconImageWebUrl: String?
        let coverImageWebUrl: String?
        var place: Place?

        
        var photosGallery: [String?]? {
            return photos?.map({ model in
                model?.photoWebUrl
            })
        }
    }
    
    

    // MARK: - Photo
    struct Photos: Codable {
        let photoWebUrl: String?
    }
    enum Rating: Codable {
        case int(Int)
        case string(String)
        case double(Double)
        case none

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
            } else if let doubleValue = try? container.decode(Double.self) {
                self = .double(doubleValue)
            } else if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            } else if container.decodeNil() {
                self = .none
            } else {
                throw DecodingError.typeMismatch(Rating.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected int, double, string, or nil for rating"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .int(let intValue):
                try container.encode(intValue)
            case .double(let doubleValue):
                try container.encode(doubleValue)
            case .string(let stringValue):
                try container.encode(stringValue)
            case .none:
                try container.encodeNil()
            }
        }
    }


    
    // MARK: - Cuisine
    // MARK: - Cuisine
    struct ModelCuisine: Codable, Hashable {
        let name: String?
        var iconImageWebUrl: String?
        
        // Implementing Hashable protocol
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
        
        static func == (lhs: ModelCuisine, rhs: ModelCuisine) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    // MARK: - Amenity
    struct Amenity: Codable {
        let type: String?
        let value: Int?
        let iconImageWebUrl: String?
    }

    // MARK: - Distance
    struct Distance: Codable {
        let distance: Double?
        let unit: String?
    }

    // MARK: - Item
    struct Review: Codable {
        let id, createdBy, createdOn, updatedBy: String?
        let updatedOn: String?
        let isDeleted: Bool?
        let type: String?
        let rating: Int?
        let comment: String?
        let willReturn: Bool?
        let place: Place?
        let user: User?
        let photoWebUrls: [String?]?
        let photos: [HomeViewController.Photos?]?
        var photosGallery: [String?]? {
            return photos?.map({ model in
                model?.photoWebUrl
            })
        }
    }
    
    // MARK: - User
    struct User: Codable {
        let id, firstName, lastName: String?
    }

    // MARK: - Timing
    struct Timing: Codable {
        let closingTime: String?
        let dayOfWeek: String?
        let openingTime: String?
    }
    
    // MARK: - WebLink
    struct WebLink: Codable {
        let type: String?
        let value: String?
    }
}


//Feature Request{
//            "location":
//            {"distanceUnit":"Miles",
//                "latitude":33.6114733,
//                "longitude":73.1733117,
//                "radius":20},
//            "orderBy":"Rating",
//            "page":1,
//            "pageSize":20,
//            "parts":["Amenities","Cuisines","Reviews","Timings","WebLinks"],"sortOrder":"Descending"}
//Halal Request
//{"alcoholPolicy":["NotAllowed"],
//    "location":
//    {"distanceUnit":"Miles",
//        "latitude":37.4220936,
//        "longitude":-122.083922,
//        "radius":20},
//    "meatHalalStatus":["Full"],
//    "page":1,"pageSize":20,
//    "parts":["Amenities","Cuisines","Reviews","Timings","WebLinks"]}
