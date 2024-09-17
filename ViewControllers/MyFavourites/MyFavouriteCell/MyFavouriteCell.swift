//
//  MyFavouriteCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class MyFavouriteCell: UITableViewCell {
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    
    var index: Int!
    var buttonDeleteHandler: ((Int) -> ())!
    var buttonCheckHandler: ((Int) -> ())!
    var selectedIndex = 0
    var selectedAddressIndex: Int? {
        didSet {
            
        }
    }
    var modelGetFavouriteResponseData: HomeViewController.ModelRestuarantResponseData? {
        didSet {
            DispatchQueue.main.async {
                self.setData()
            }
        }
    }
    
    func setData() {
        if modelGetFavouriteResponseData != nil {
            labelTitle.text = modelGetFavouriteResponseData?.place?.name ?? ""
            let completeAddress = "\(modelGetFavouriteResponseData?.place?.address ?? "")\n\(modelGetFavouriteResponseData?.place?.city ?? ""), \(modelGetFavouriteResponseData?.place?.state ?? "")"
            
            labelAddress.text = completeAddress
            imageViewRestaurant.setImage(urlString: modelGetFavouriteResponseData?.place?.iconImageWebUrl ?? "", placeHolderIcon: selectedIndex == 0 ? "placeHolderRestaurant" : "placeholderMosque2")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackGroundForRadius.setShadow(radius: 12)
        stackViewBackGround.radius(radius: 12)
        imageViewRestaurant.circle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonDelete(_ sender: UIButton) {
        buttonDeleteHandler?(index)
    }
    @IBAction func buttonCheck(_ sender: Any) {
        buttonCheckHandler?(index)
    }
    
}
