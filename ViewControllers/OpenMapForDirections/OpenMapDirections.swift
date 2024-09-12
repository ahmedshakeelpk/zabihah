//
//  OpenMapDirections.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 29/08/2024.
//

import Foundation
import UIKit
import MapKit

class OpenMapDirections {
    // If you are calling the coordinate from a Model, don't forgot to pass it in the function parenthesis.
    static func present(in viewController: UIViewController, sourceView: UIView, latitude: Double, longitude: Double, locationAddress: String) {
        let actionSheet = UIAlertController(title: "Get directions", message: "Select your preferred map app", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            //MARK: - With Complete Address
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                if let url = URL(string:"comgooglemaps://?q=\(locationAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                }
                //MARK: - With Latitude Longitude
//                if let url = URL(string: "http://maps.google.com/?daddr=\(latitude),\(longitude)&directionsmode=driving") {
//                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
//                }
            }
            else {
//                let stringUrl = "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: latitude)),\(String(describing: longitude))"
                
                let encodedAddress = locationAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

                let urlString = "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)"

                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                }
            }
        }))
//        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
//            // Pass the coordinate that you want here
//            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
//            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
//            mapItem.name = locationAddress //"Destination"
//            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//        }))
        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
