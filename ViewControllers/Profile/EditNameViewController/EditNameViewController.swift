//
//  EditNameViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 05/07/2024.
//

import UIKit

class EditNameViewController: UIViewController {
    @IBOutlet weak var viewBackGroundButtonSave: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        viewBackGroundButtonSave.radius(radius: 8)

    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }

}
