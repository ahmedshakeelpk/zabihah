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
    static func present(in viewController: UIViewController, sourceView: UIView, latitude: Double, longitude: Double, locationName: String) {
        let actionSheet = UIAlertController(title: "Open Location", message: "Choose an app to open direction", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                if let url = URL(string: "http://maps.google.com/?daddr=\(latitude),\(longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                }
            }
            else {
                let stringUrl = "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: latitude)),\(String(describing: longitude))"
                if let url = URL(string: stringUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            // Pass the coordinate that you want here
            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = locationName //"Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }))
        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
