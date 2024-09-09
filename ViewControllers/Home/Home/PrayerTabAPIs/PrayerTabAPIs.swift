//
//  PrayerTabAPIs.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/09/2024.
//

import Foundation
import Alamofire

extension HomeViewController {
    func getPrayerPlaces(pageSize: Int) {
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
            keyword: textFieldFilterResult.text!,
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
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: .searchMosque, parameters: parameters, encoding: JSONEncoding.default, viewController: self) { responseData, success, errorMsg, statusCode in
            var model: ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            
            if self.pageNumberForApi > 1 {
                if let record = self.modelGetPrayerPlacesResponse?.items {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.items ?? [])
                    model?.items = oldModel
                }
            }
            self.modelGetPrayerPlacesResponse = model
        }
    }
}
