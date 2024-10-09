//
//  ProfileDeleteViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 13/07/2024.
//

import UIKit

class ProfileDeleteViewController: UIViewController {

    @IBOutlet weak var stackViewDescriptionBackGround: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelButtonDelete: UILabel!
    
    @IBOutlet weak var buttonDeleteMyAccount: UIButton!
    @IBOutlet weak var viewButtonDeleteMyAccountBackGround: UIView!
    @IBOutlet weak var viewButtonCancelBackGround: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelButtonCancel: UILabel!
    
    var buttonDeleteHandler: (() -> ())!
    var stringTitle: String? = ""
    var stringSubTitle: String? = ""
    var stringDescription: String? = ""
    var stringButtonDelete: String? = ""
    var stringButtonCancel: String? = ""
    
    override func viewDidAppear(_ animated: Bool) {
        viewButtonDeleteMyAccountBackGround.radius(radius: 8)
        viewButtonCancelBackGround.radius(color: .clrLightGray, borderWidth: 1)
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setData()
    }
    
    func setData() {
        labelTitle.text = stringTitle
        labelSubTitle.text = stringSubTitle
        labelDescription.text = stringDescription
        labelButtonDelete.text = stringButtonDelete
        labelButtonCancel.text = stringButtonCancel
        
        stackViewDescriptionBackGround.isHidden = stringDescription == ""
        labelTitle.isHidden = stringTitle == ""
        labelDescription.textAlignment = stringTitle != "" ? .left : .center
        labelSubTitle.textAlignment = stringTitle != "" ? .left : .center
    }
    @IBAction func buttonDeleteMyAccount(_ sender: Any) {
        self.dismiss(animated: true) {
            self.buttonDeleteHandler?()
        }
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
