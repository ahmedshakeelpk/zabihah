//
//  HomeFilterViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 22/07/2024.
//

import UIKit

class HomeFilterViewController: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var rangeSlider: RangeSlider! {
        didSet {
            labelRangeStart.text = "\(Int(rangeSlider.lowerValue))"
            labelRangeEnd.text = "\(Int(rangeSlider.upperValue))"
        }
    }
    @IBOutlet weak var labelRangeStart: UILabel!
    @IBOutlet weak var labelRangeEnd: UILabel!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var switchHideHalalPlaces: UISwitch! {
        didSet{
            switchHideHalalPlaces.onTintColor = .clrApp
        }
    }
    @IBOutlet weak var switchHideAlcoholPlaces: UISwitch! {
        didSet{
            switchHideAlcoholPlaces.onTintColor = .clrApp
        }
    }

    @IBOutlet weak var buttonCross: UIButton!
    
    var buttonFilterHandler: (([String: Any]) -> ())!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
        viewBackGround.roundCorners(corners: [.topRight, .topLeft], radius: 20)

    }
    @IBAction func buttonFilter(_ sender: Any) {
        self.dismiss(animated: true) {
            let parameters = [
                "String" : "Any",
                "Int" : 2
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
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
      print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        
        
        labelRangeStart.text = "\(Int(rangeSlider.lowerValue))"
        labelRangeEnd.text = "\(Int(rangeSlider.upperValue))"
    }
}
