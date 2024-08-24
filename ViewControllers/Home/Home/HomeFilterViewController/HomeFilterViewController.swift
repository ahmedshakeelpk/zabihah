//
//  HomeFilterViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 22/07/2024.
//

import UIKit
import GooglePlaces
import Cosmos

class HomeFilterViewController: UIViewController {
    
    @IBOutlet weak var sliderRange: UISlider!
    @IBOutlet weak var starRatingView: CosmosView!
    
    @IBOutlet weak var labelStarRating: UILabel!
    @IBOutlet weak var viewBackGround: UIView!
//    @IBOutlet weak var rangeSlider: RangeSlider! {
//        didSet {
////            labelRangeStart.text = "\(Int(rangeSlider.lowerValue))"
//            labelRangeEnd.text = "\(Int(sliderRange?.maximumValue ?? 0))"
//            rangeSlider.maximumValue = 20
//            labelRangeEnd.text = "\(Int(rangeSlider.maximumValue))ml"
//            
//            if kModelUserConfigurationResponse != nil {
//                rangeSlider.maximumValue = Double(kModelUserConfigurationResponse.distanceValue ?? 0)
//                labelRangeEnd.text = "\(Int(rangeSlider.maximumValue))\(kModelUserConfigurationResponse.distanceUnit ?? "ml")"
//            }
//        }
//    }
    @IBOutlet weak var labelRangeStart: UILabel!
    @IBOutlet weak var labelRangeEnd: UILabel!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var switchHideHalalPlaces: UISwitch! {
        didSet{
            switchHideHalalPlaces.onTintColor = .colorApp
        }
    }
    @IBOutlet weak var switchHideAlcoholPlaces: UISwitch! {
        didSet{
            switchHideAlcoholPlaces.onTintColor = .colorApp
        }
    }
    
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var stackViewHalalAlCohal: UIStackView!

    var filterParametersHome: [String: Any]!
    var buttonFilterHandler: (([String: Any]) -> ())!
    var location: CLLocationCoordinate2D? {
        didSet {
            
            
        }
    }
    
    var selectedMenuCell = 0 {
        didSet {

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBackGround.roundCorners(corners: [.topRight, .topLeft], radius: 20)
        getStarRating()
        setSliderRange()
        if filterParametersHome != nil {
            if let radius = filterParametersHome["radius"] as? String {
                labelRangeEnd.text = "\(radius)\(kModelUserConfigurationResponse.distanceUnit ?? "ml")"
                
                sliderRange.value = Float(radius) ?? 0
            }
            if let rating = filterParametersHome["rating"] as? String {
                labelStarRating.text = rating
                starRatingView.rating = Double(rating) ?? 0
            }
            if let isAlCoholic = filterParametersHome["isalcoholic"] as? Bool {
                switchHideAlcoholPlaces.isOn = isAlCoholic
            }
            if let isHalal = filterParametersHome["isHalal"] as? Bool {
                switchHideHalalPlaces.isOn = isHalal
            }
        }
        if selectedMenuCell == 3 {
            stackViewHalalAlCohal.isHidden = true
        }
        else {
            stackViewHalalAlCohal.isHidden = false
        }
    }
    var sliderDefaultValue = Float(20)
    func setSliderRange() {
        sliderRange.maximumValue = sliderDefaultValue //Default
        sliderRange.value = sliderRange.maximumValue //Default
        labelRangeEnd.text = "\(Int(sliderRange?.value ?? 0))" //Default
        
        if kModelUserConfigurationResponse != nil {
            sliderRange.maximumValue = Float(Double(kModelUserConfigurationResponse.distanceValue ?? 0))
            sliderRange.value = sliderRange.maximumValue
            labelRangeEnd.text = "\(Int(sliderRange.value))\(kModelUserConfigurationResponse.distanceUnit ?? "ml")"
        }
    }
    
    func getStarRating() {
        starRatingView.didTouchCosmos = { [self] rating in
            labelStarRating.text = "\(starRatingView.rating)"
        }
    }
    @IBAction func sliderRange(_ sender: UISlider) {
        labelRangeEnd.text = "\(Int(sender.value))\(kModelUserConfigurationResponse.distanceUnit ?? "ml")"
    }
    @IBAction func buttonFilter(_ sender: Any) {
        self.dismiss(animated: true) {
            let parameters = [
                "lat": self.location?.latitude ?? 0,
                "long": self.location?.longitude ?? 0,
                "radius": self.labelRangeEnd.text!.getIntegerValue(),
                "rating": self.labelStarRating.text!,
                "isalcoholic": self.switchHideAlcoholPlaces.isOn,
                "isHalal": self.switchHideHalalPlaces.isOn
            ] as! [String: Any]
            
            self.buttonFilterHandler?(parameters)
        }
    }
    
    @IBAction func buttonCross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func switchHideHalalPlaces(_ sender: Any) {
    }
    @IBAction func switchHideAlcoholPlaces(_ sender: Any) {
    }
}


