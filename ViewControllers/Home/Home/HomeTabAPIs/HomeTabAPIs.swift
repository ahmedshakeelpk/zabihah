//
//  HomeTabAPIs.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/09/2024.
//

import Foundation
import Alamofire

extension HomeViewController {
    func getFeaturedRestaurantsForHomeTab() {
        var useRadius = 32
        if let radius = kModelUserConfigurationResponse?.distance?.distance {
            useRadius = radius
        }
        else {
            useRadius = Int(filterParametersHome?.radius ?? "32") ?? 32
        }
        var parameters = [String: Any]()
        let featureRequestModel: ModelFeaturedRequest = ModelFeaturedRequest(
            ids: nil,
            rating: filterParametersHome?.rating,
            page: 1,
            pageSize: 32,
            cuisine: nil,
            meatHalalStatus: filterParametersHome?.isHalal ?? false ? [.full] : nil,
            alcoholPolicy: filterParametersHome?.isalcoholic ?? false ? nil : [.notAllowed],
            parts: [.cuisines, .timings],
            orderBy: .ratingAndLocation,
            sortOrder: .descending,
            location: Location(
                distanceUnit: DistanceUnit.miles,
                latitude: userLocation?.coordinate.latitude ?? 0.0,
                longitude: userLocation?.coordinate.longitude ?? 0.0,
                radius: useRadius
            )
        )
        do {
            let jsonData = try JSONEncoder().encode(featureRequestModel)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                someFunctionAcceptingDictionary(jsonDict)
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: .search, parameters: parameters, encoding: JSONEncoding.default, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            //            self.modelGetHomeRestaurantsResponse = nil
            self.modelGetHomeRestaurantsResponseForHome = model
        }
    }
    
    func getHalalRestaurantsForHomeTab() {
        var useRadius = 32
        if let radius = kModelUserConfigurationResponse?.distance?.distance {
            useRadius = radius
        }
        else {
            useRadius = Int(filterParametersHome?.radius ?? "32") ?? 32
        }
        var parameters = [String: Any]()
        let featureRequestModel: ModelFeaturedRequest = ModelFeaturedRequest(
            ids: nil,
            rating: filterParametersHome?.rating,
            page: 1,
            pageSize: 32,
            cuisine: nil,
            meatHalalStatus: filterParametersHome?.isHalal ?? false ? [.full] : nil,
            alcoholPolicy: filterParametersHome?.isalcoholic ?? false ? nil : [.notAllowed],
            parts: [.cuisines, .timings],
            //            parts: [.amenities, .cuisines, .reviews, .timings, .webLinks],
            orderBy: .location,
            sortOrder: .ascending,
            location: Location(
                distanceUnit: .kilometers,
                latitude: userLocation?.coordinate.latitude ?? 0.0,
                longitude: userLocation?.coordinate.longitude ?? 0.0,
                radius: useRadius
            )
        )
        do {
            let jsonData = try JSONEncoder().encode(featureRequestModel)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                someFunctionAcceptingDictionary(jsonDict)
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: .search, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetHalalRestaurantResponseForHomeTab = model
        }
    }
    func getPrayerPlacesForHomeTab() {
        var useRadius = 32
        if let radius = kModelUserConfigurationResponse?.distance?.distance {
            useRadius = radius
        }
        else {
            useRadius = Int(filterParametersHome?.radius ?? "32") ?? 32
        }
        var parameters = [String: Any]()
        let featureRequestModel: ModelFeaturedRequest = ModelFeaturedRequest(
            ids: nil,
            rating: filterParametersHome?.rating,
            page: 1,
            pageSize: 20,
            cuisine: nil,
            meatHalalStatus: nil,
            alcoholPolicy: nil,
            parts: [.cuisines, .timings],
            //            parts: [.amenities, .cuisines, .reviews, .timings, .webLinks],
            orderBy: .location,
            sortOrder: .ascending,
            location: Location(
                distanceUnit: .kilometers,
                latitude: userLocation?.coordinate.latitude ?? 0.0,
                longitude: userLocation?.coordinate.longitude ?? 0.0,
                radius: useRadius
            )
        )
        do {
            let jsonData = try JSONEncoder().encode(featureRequestModel)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                someFunctionAcceptingDictionary(jsonDict)
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: .mosqueSearch, parameters: parameters, encoding: JSONEncoding.default, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetPrayerPlacesResponseForHomeTab = model
        }
    }
}
