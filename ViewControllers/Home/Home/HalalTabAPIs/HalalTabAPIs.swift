//
//  HalalTabAPIs.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/09/2024.
//

import Foundation
import Alamofire

extension HomeViewController {
    func getHalalRestaurants(pageSize: Int, cuisine: String) {
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
            page: pageSize,
            keyword: textFieldFilterResult.text! == "" ? nil : textFieldFilterResult.text!,
            pageSize: 20,
            cuisine: selectedCuisine == "" ? nil : [selectedCuisine],
            meatHalalStatus: filterParametersHome?.isHalal == nil ? nil : filterParametersHome?.isHalal ?? false ? [.full] : nil,
            alcoholPolicy: filterParametersHome?.isalcoholic == nil ? nil : filterParametersHome?.isalcoholic ?? false ? nil : [.notAllowed],
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
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: .searchRestaurant, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            var model: ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            
            if self.pageNumberForApi > 1 {
                if let record = self.modelGetHalalRestaurantResponse?.items {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.items ?? [])
                    model?.items = oldModel
                }
            }
            self.modelGetHalalRestaurantResponse = model
        }
    }
    
    
    func getHalalCuisines(pageSize: Int, cuisine: String) {
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
            page: pageSize,
            keyword: textFieldFilterResult.text! == "" ? nil : textFieldFilterResult.text!,
            pageSize: 20,
            cuisine: selectedCuisine == "" ? nil : [selectedCuisine],
            meatHalalStatus: filterParametersHome?.isHalal == nil ? nil : filterParametersHome?.isHalal ?? false ? [.full] : nil,
            alcoholPolicy: filterParametersHome?.isalcoholic == nil ? nil : filterParametersHome?.isalcoholic ?? false ? nil : [.notAllowed],
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
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: .searchCuisineRestaurant, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            var model: ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            
            if self.pageNumberForApi > 1 {
                if let record = self.modelGetHalalRestaurantResponse?.items {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.items ?? [])
                    model?.items = oldModel
                }
            }
            self.modelGetHalalRestaurantResponse = model
        }
    }
}

