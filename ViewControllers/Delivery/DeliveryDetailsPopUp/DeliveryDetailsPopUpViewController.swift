//
//  DeliveryDetailsPopUpViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 13/09/2024.
//

import UIKit

class DeliveryDetailsPopUpViewController: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var viewButtonCancelBackGround: UIView!
    
    
    @IBOutlet weak var stackViewCallBackGround: UIStackView!
    @IBOutlet weak var stackViewMosqueBackGround: UIStackView!
    @IBOutlet weak var stackViewRestaurantBackGround: UIStackView!
    @IBOutlet weak var stackViewMapBackGround: UIStackView!
    @IBOutlet weak var labelTitleName: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var isCallIcon: Bool = true
    var isMosqueIcon: Bool = true
    var isRestaurantIcon: Bool = true
    var isMapIcon: Bool = true
    
    var titleName = ""
    var tappedOnCallHandler: (() -> ())!
    var tappedOnDetailViewHandler: (() -> ())!
    var tappedOnMapHandler: (() -> ())!
    
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setConfiguration()
    }
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonCall(_ sender: Any) {
        self.dismiss(animated: true)
        tappedOnCallHandler?()
    }
    @IBAction func buttonViewDetails(_ sender: Any) {
        self.dismiss(animated: true)
        tappedOnDetailViewHandler?()
    }
    @IBAction func buttonMap(_ sender: Any) {
        self.dismiss(animated: true)
        tappedOnMapHandler?()
    }
    
    func setConfiguration() {
        viewButtonCancelBackGround.radius(radius: 8)
        labelTitleName.text = titleName
        stackViewCallBackGround.isHidden = !isCallIcon
        stackViewMosqueBackGround.isHidden = !isMosqueIcon
        stackViewRestaurantBackGround.isHidden = !isRestaurantIcon
        stackViewMapBackGround.isHidden = !isMapIcon
    }
}
