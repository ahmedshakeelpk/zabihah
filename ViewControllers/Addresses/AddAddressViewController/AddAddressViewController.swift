//
//  AddAddressViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit
import GoogleMaps

class AddAddressViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewAddressSubBackGround: UIView!
    @IBOutlet weak var viewAddressBackGround: UIView!
    @IBOutlet weak var stackViewSearchBackGround: UIStackView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewButtonBackBackGround: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        setLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewButtonBackBackGround.radius(radius: 8)
        viewAddressSubBackGround.radius(radius: 8)
        stackViewSearchBackGround.radius(radius: 8)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
        
    }

    func setLocation() {
        let lat = 47.07903
            let long = -122.961283

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        let map = GMSMapView.map(withFrame: CGRectZero, camera: camera)
        map.isMyLocationEnabled = true
            map.delegate = self
            self.mapView.addSubview(map)

            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lat, long)
            marker.map = self.mapView
    }
}
