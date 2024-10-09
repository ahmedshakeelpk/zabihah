//
//  HomeViewControllerGoogleMapDelegate.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/08/2024.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 170, height: 135))
        let infoView = Bundle.loadView(fromNib: "MarkerInfoView", withType: MarkerInfoView.self)
        view.addSubview(infoView)
        if let modelData = marker.userData as? HomeViewController.ModelRestuarantResponseData {
            infoView.modelRestuarantResponseData = modelData
        }
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("when click on info View")
        if let userData = marker.userData as? HomeViewController.ModelRestuarantResponseData {
//            asdfasdf
            self.dialNumber(isMapDirection: true, isPrayerPlaces: false, name: userData.name ?? "", number: userData.phone ?? "", isActionSheet: true) { actionType in
                print(actionType)
                let indexPath = IndexPath(row: Int(marker.zIndex), section: 1)
                self.navigateToDeliveryDetailsViewController(indexPath: indexPath, actionType: actionType ?? "viewdetails")
            }
        }
    }
    
    @objc func tapOnMapInfoView() {
        print("tapOnMapInfoView")
        print("when click on info View")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.icon = UIImage(named: "markerHomeSelected")
        return false // return false to display info window
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "markerHome")
    }
}

extension HomeViewController {
    func drawMarkerOnMap(modelRestuarantResponseData: HomeViewController.ModelRestuarantResponseData?, index: Int) {
        if let modelRestuarantResponseData = modelRestuarantResponseData {
            /// Marker - Google Place marker
            let marker: GMSMarker = GMSMarker() // Allocating Marker
            marker.title = modelRestuarantResponseData.name // Setting title
            marker.snippet = modelRestuarantResponseData.address // Setting sub title
            marker.icon = UIImage(named: "markerHome") // Marker icon
            marker.appearAnimation = .pop // Appearing animation. default
            marker.userData = modelRestuarantResponseData
            marker.zIndex = Int32(index)
            
            let location = CLLocationCoordinate2D(latitude: modelRestuarantResponseData.latitude ?? 0, longitude: modelRestuarantResponseData.longitude ?? 0)
            marker.position = location
            marker.map = self.mapView // Setting marker on Mapview
            //        setZoom(location: location)
            self.mapView.delegate = self
        }
    }
    
    func drawMarkerOnMapPrayerPlaces(modelRestuarantResponseData: HomeViewController.ModelRestuarantResponseData?, index: Int) {
        /// Marker - Google Place marker
        let marker: GMSMarker = GMSMarker() // Allocating Marker
        marker.title = modelRestuarantResponseData?.name // Setting title
        marker.snippet = modelRestuarantResponseData?.address // Setting sub title
        marker.icon = UIImage(named: "markerPrayerPlaces") // Marker icon
        marker.appearAnimation = .pop // Appearing animation. default
        marker.userData = modelRestuarantResponseData
        
        let location = CLLocationCoordinate2D(latitude: modelRestuarantResponseData?.latitude ?? 0, longitude: modelRestuarantResponseData?.longitude ?? 0)
        marker.position = location
        marker.map = self.mapView // Setting marker on Mapview
        
//        setZoom(location: location)
        self.mapView.delegate = self
    }
    
    func setZoom(location: CLLocationCoordinate2D) {
        let lat = location.latitude
        let long = location.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        self.mapView.camera = camera
    }
}
