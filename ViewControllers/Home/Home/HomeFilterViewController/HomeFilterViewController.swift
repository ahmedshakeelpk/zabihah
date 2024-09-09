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
    @IBOutlet weak var viewTitleGrayImage: UIView!
    
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

    var filterParametersHome: HomeViewController.ModelFilterRequest!
    var buttonFilterHandler: ((HomeViewController.ModelFilterRequest) -> ())!
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
        viewTitleGrayImage.circle()
        viewBackGround.roundCorners(corners: [.topRight, .topLeft], radius: 20)
        getStarRating()
        setSliderRange()
        if filterParametersHome != nil {
            let km = (kModelUserConfigurationResponse.distance?.unit ?? "").lowercased() == HomeViewController.DistanceUnit.kilometers.rawValue.lowercased() ? "km" : "ml"
            if let radius = filterParametersHome.radius {
                labelRangeEnd.text = "\(radius)\(km)"
                
                sliderRange.value = Float(radius) ?? 0
            }
            if let rating = filterParametersHome.radius {
                labelStarRating.text = rating
                starRatingView.rating = Double(rating) ?? 0
            }
            if let isAlCoholic = filterParametersHome.isalcoholic {
                switchHideAlcoholPlaces.isOn = isAlCoholic
            }
            if let isHalal = filterParametersHome.isHalal{
                switchHideHalalPlaces.isOn = isHalal
            }
                
//            if let radius = filterParametersHome["radius"] as? String {
//                labelRangeEnd.text = "\(radius)\(kModelUserConfigurationResponse.distanceUnit ?? "ml")"
//                
//                sliderRange.value = Float(radius) ?? 0
//            }
//            if let rating = filterParametersHome["rating"] as? String {
//                labelStarRating.text = rating
//                starRatingView.rating = Double(rating) ?? 0
//            }
//            if let isAlCoholic = filterParametersHome["isalcoholic"] as? Bool {
//                switchHideAlcoholPlaces.isOn = isAlCoholic
//            }
//            if let isHalal = filterParametersHome["isHalal"] as? Bool {
//                switchHideHalalPlaces.isOn = isHalal
//            }
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
            sliderRange.maximumValue = Float(Double(kModelUserConfigurationResponse?.distance?.distance ?? 0))
            sliderRange.value = sliderRange.maximumValue
            labelRangeEnd.text = "\(Int(sliderRange.value))\(kModelUserConfigurationResponse.distance?.unit ?? "ml")"
        }
    }
    
    func getStarRating() {
        starRatingView.didTouchCosmos = { [self] rating in
            labelStarRating.text = "\(starRatingView.rating)"
        }
    }
    @IBAction func sliderRange(_ sender: UISlider) {
        labelRangeEnd.text = "\(Int(sender.value))\(kModelUserConfigurationResponse.distance?.unit ?? "ml")"
    }
    @IBAction func buttonFilter(_ sender: Any) {
        self.dismiss(animated: true) {
//            let parameters = [
//                "lat": self.location?.latitude ?? 0,
//                "long": self.location?.longitude ?? 0,
//                "radius": self.labelRangeEnd.text!.getIntegerValue(),
//                "rating": self.labelStarRating.text!,
//                "isalcoholic": self.switchHideAlcoholPlaces.isOn,
//                "isHalal": self.switchHideHalalPlaces.isOn
//            ] as! [String: Any]
            var parameter = HomeViewController.ModelFilterRequest(
                radius: self.labelRangeEnd.text!.getIntegerValue(),
                rating: Int(self.labelStarRating.text!),
                isalcoholic: self.switchHideAlcoholPlaces.isOn,
                isHalal: self.switchHideHalalPlaces.isOn)
            
            self.buttonFilterHandler?(parameter)
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



class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 8
    
    @IBInspectable var thumbRadius: CGFloat = 25
    
    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white//thumbTintColor
        thumb.layer.borderWidth = 1
        thumb.layer.borderColor = UIColor.colorApp.cgColor
        return thumb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
}
