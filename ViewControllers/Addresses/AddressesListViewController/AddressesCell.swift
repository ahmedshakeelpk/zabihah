//
//  AddressesCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class AddressesCell: UITableViewCell {
    @IBOutlet weak var imageViewAddressType: UIImageView!
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewButtonDeleteBackGround: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewCheck: UIImageView!
    
    var index: Int!
    var buttonDeleteHandler: ((Int) -> ())!
    var buttonEditHandler: ((Int) -> ())!
    var buttonCheckHandler: ((Int) -> ())!
    
    var selectedAddressIndex: Int? {
        didSet {
            if index == selectedAddressIndex {
                imageViewCheck.image = UIImage(named: "checkBoxAddresses")
            }
            else {
                imageViewCheck.image = UIImage(named: "unCheckBoxAddresses")
            }
        }
    }
    let arrayNamesIconMehroon = ["houseMehroon", "briefcaseMehroon", "userMehroon", "addCircleMehroon"]

    var modelUserAddressesResponseData: AddressesListViewController.ModelUserAddressesResponseData? {
        didSet {
            if modelUserAddressesResponseData != nil {
                labelTitle.text = modelUserAddressesResponseData?.name ?? ""
                
//                labelAddress.text = "\(modelUserAddressesResponseData?.address ?? ""), \(modelUserAddressesResponseData?.secondaryAddress ?? "")\n\(modelUserAddressesResponseData?.city ?? ""), \(modelUserAddressesResponseData?.state ?? "") \(modelUserAddressesResponseData?.zip ?? "")"
                
                labelAddress.text = modelUserAddressesResponseData?.physicalAddress ?? ""
                if "Home".lowercased() == (modelUserAddressesResponseData?.name ?? "").lowercased() {
                    imageViewAddressType.image = UIImage(named: "houseMehroon")
                }
                else if "Office".lowercased() == (modelUserAddressesResponseData?.name ?? "").lowercased() {
                    imageViewAddressType.image = UIImage(named: "briefcaseMehroon")
                }
                else if "Person".lowercased() == (modelUserAddressesResponseData?.name ?? "").lowercased() {
                    imageViewAddressType.image = UIImage(named: "userMehroon")
                }
                else {
                    imageViewAddressType.image = UIImage(named: "addCircleMehroon")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackGroundForRadius.setShadow(radius: 12)
        stackViewBackGround.radius(radius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonDelete(_ sender: UIButton) {
        buttonDeleteHandler?(index)
    }
    @IBAction func buttonEdit(_ sender: UIButton) {
        buttonEditHandler?(index)
    }
    @IBAction func buttonCheck(_ sender: Any) {
        buttonCheckHandler?(index)
    }
    
}
