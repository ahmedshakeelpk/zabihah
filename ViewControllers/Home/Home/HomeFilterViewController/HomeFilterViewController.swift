//
//  HomeFilterViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 22/07/2024.
//

import UIKit

class HomeFilterViewController: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonFilter(_ sender: Any) {
    }
    
    @IBAction func buttonCross(_ sender: Any) {
        self.popViewController(animated: true)
    }
    @IBAction func switchHideHalalPlaces(_ sender: Any) {
    }
    @IBAction func switchHideAlcoholPlaces(_ sender: Any) {
    }
}
