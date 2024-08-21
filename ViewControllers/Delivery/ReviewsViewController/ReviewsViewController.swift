//
//  ReviewsViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 21/08/2024.
//

import UIKit
import Alamofire

class ReviewsViewController: UIViewController {
    @IBOutlet weak var imageViewNoDataFound: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var buttonHalalFood: UIButton!
    @IBOutlet weak var viewBottomLinePrayerSpaces: UIView!
    @IBOutlet weak var viewBottomLineHalalFood: UIView!
    @IBOutlet weak var imageViewHalalFood: UIImageView!
    @IBOutlet weak var imageViewMosque: UIImageView!
    @IBOutlet weak var buttonPrayerSpaces: UIButton!
    
    var isPrayerPlace: Bool = false
    
    var modelEditUserAddressResponse: AddAddressViewController.ModelEditUserAddressResponse? {
        didSet {
            if modelEditUserAddressResponse?.success ?? false {
                
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelEditUserAddressResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTitle.radius(radius: 12)
        imageViewNoDataFound.isHidden = true
        AddressesCell.register(tableView: tableView)
    }

    @IBAction func buttonBack(_ sender: Any) {
        
        popViewController(animated: true)
    }
    
    

    @IBAction func buttonHalalFood(_ sender: Any) {
        buttonHalalFood.tag = 1
        
        viewBottomLinePrayerSpaces.isHidden = true
        viewBottomLineHalalFood.isHidden = false
        imageViewHalalFood.tintColor = .colorApp
        imageViewMosque.tintColor = .clrUnselectedImage
    }
    @IBAction func buttonPrayerSpaces(_ sender: Any) {
        buttonHalalFood.tag = 0
        
        viewBottomLinePrayerSpaces.isHidden = false
        viewBottomLineHalalFood.isHidden = true
        imageViewHalalFood.tintColor = .clrUnselectedImage
        imageViewMosque.tintColor = .colorApp
    }
    

    func editUserAddress(index: Int) {
        let parameters: Parameters = [
              "type": isPrayerPlace ? "prayer" : "rest",
              "reviewType": buttonHalalFood.tag == 1 ? "" : "",
              "page": 1,
              "pageSize": 0
        ]
        APIs.postAPI(apiName: .getbyuser, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg in
            let model: AddAddressViewController.ModelEditUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelEditUserAddressResponse = model
        }
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell") as! AddressesCell
        cell.modelUserAddressesResponseData = modelGetUserAddressResponse?.userAddressesResponseData?[indexPath.row]
        cell.index = indexPath.row
        cell.selectedAddressIndex = selectedAddressIndex
        cell.buttonEditHandler = buttonEditAddress
        cell.buttonDeleteHandler = buttonDeleteAddress
        cell.buttonCheckHandler = buttonCheckHandler
        
        if modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0 == 1 {
            cell.viewButtonDeleteBackGround.isHidden = true
        }
        else {
            cell.viewButtonDeleteBackGround.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        selectedAddressIndex = indexPath.row
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                if let targetViewController = controller as? HomeViewController {
                    targetViewController.getuser()
                    if let model = modelGetUserAddressResponse?.userAddressesResponseData?[indexPath.row] {
                        targetViewController.selectedAddress(modelUserAddressesResponseData: model)
                    }
                    self.navigationController!.popToViewController(controller, animated: true)
                }
                break
            }
        }
    }
}
