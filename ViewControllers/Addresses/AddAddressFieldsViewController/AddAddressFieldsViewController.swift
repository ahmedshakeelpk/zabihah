//
//  AddAddressFieldsViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import UIKit

class AddAddressFieldsViewController: UIViewController {
    @IBOutlet weak var viewAddNewAddressBackGround: UIView!
    @IBOutlet weak var textFieldLocationInstructionOptional: UITextField!
    @IBOutlet weak var labelDeliveryInstructionCount: UILabel!
    @IBOutlet weak var textFieldDeliveryInstruction: UITextField!
    
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchDefaultAddress: UISwitch!
    @IBOutlet weak var viewButtonSaveBackGround: UIView!
    @IBOutlet weak var viewSwitchDefaultAddressBackGround: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewButtonBackBackGround: UIView!
    
    let arrayNames = ["Home", "Office", "Person", "Other"]
    let arrayNamesIcon = ["houseWhiteMisc", "briefcaseBlackMisc", "userBlackMisc", "addCircleBlackMisc"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtonBackBackGround.radius(radius: 8)
        viewButtonSaveBackGround.radius(radius: 8)
        viewSwitchDefaultAddressBackGround.radius(radius: 8)
        viewAddNewAddressBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        AddAddressFieldsCell.register(collectionView: collectionView)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }

    @IBAction func switchDefaultAddress(_ sender: Any) {
    }
}


extension AddAddressFieldsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
        let width = collectionView.frame.width / 3 - 8
        return CGSize(width: 60, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressFieldsCell", for: indexPath) as! AddAddressFieldsCell
        cell.labelName.text = arrayNames[indexPath.item]
        cell.imageViewTitle.image = UIImage(named: arrayNamesIcon[indexPath.item])
        if indexPath.item == 0 {
            cell.viewImageViewTitleBackGround.backgroundColor = .clrApp
        }
        else {
            cell.viewImageViewTitleBackGround.backgroundColor = .clrUnselected
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}
