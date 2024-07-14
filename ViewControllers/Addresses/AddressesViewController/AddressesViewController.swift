//
//  AddressesViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit
import Alamofire

class AddressesViewController: UIViewController {

    @IBOutlet weak var buttonAddNewAddress: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    var modelGetUserAddressResponse: ModelGetUserAddressResponse? {
        didSet {
            if modelGetUserAddressResponse?.status == 500 {
                
            }
            else {
                tableView.reloadData()
            }
        }
    }
    
    var arrayTitle = ["Mango", "Ferrerri", "Toyota", "Honda", "Cycle", "iPhone", "Android", "Serina"]
    var arrayAddress = ["A quick brown", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressesCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)
        getUserAddress()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonAddNewAddress(_ sender: Any) {
        navigateToAddAddressViewController()
    }
    
    func navigateToEditAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func getUserAddress() {
        APIs.postAPI(apiName: .getuseraddress, methodType: .get, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
    
    func addUserAddress() {
        let parameters: Parameters = [
            "id": modelGetUserAddressResponse?.id ?? ""
        ]
        APIs.postAPI(apiName: .deleteuseraddress, parameters: parameters, methodType: .delete, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetUserAddressResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserAddressResponse = model
        }
    }
}

extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell") as! AddressesCell
        cell.labelTitle.text = arrayTitle[indexPath.row]
        cell.labelAddress.text = arrayAddress[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    }
}
