//
//  FAQsViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 17/08/2024.
//

import UIKit

class FAQsViewController: UIViewController {
    // MARK: - ModelGetFAQsResponse
    struct ModelGetFAQsResponse: Codable {
        let faqResponseModel: [FAQResponseModel]?
        let totalPages: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        let totalFavorities: Int?
        let recordFound: Bool?
    }

    // MARK: - FAQResponseModel
    struct FAQResponseModel: Codable {
        let answer, question: String?
    }

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewNoAddressFound: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTitle: UIView!

    var arraySelectedFAQs: [Int]! {
        didSet {
            
        }
    }

    var modelGetFAQsResponse: ModelGetFAQsResponse? {
        didSet {
            if modelGetFAQsResponse?.faqResponseModel?.count ?? 0 > 0 {
                imageViewNoAddressFound.isHidden = false
            }
            else {
                imageViewNoAddressFound.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FAQsViewControllerCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)

        getFAQs()
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    

    func getFAQs() {
        APIs.postAPI(apiName: .getfaq, methodType: .get, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetFAQsResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetFAQsResponse = model
        }
    }

}


extension FAQsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return modelGetUserAddressResponse?.userAddressesResponseData?.count ?? 0
        return modelGetFAQsResponse?.faqResponseModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsViewControllerCell") as! FAQsViewControllerCell
        let modelFAQsData = modelGetFAQsResponse?.faqResponseModel?[indexPath.row]
        cell.labelQuestion.text = modelFAQsData?.question ?? ""
        cell.imageViewDropDown.image = UIImage(named: arraySelectedFAQs?.contains(indexPath.row) ?? false ? "arrowDropDown" : "forwardArrowGray")
        cell.labelAnswer.text = arraySelectedFAQs?.contains(indexPath.row) ?? false ? modelFAQsData?.answer ?? "" : ""
        cell.labelAnswer.isHidden = !(arraySelectedFAQs?.contains(indexPath.row) ?? false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
       
        if arraySelectedFAQs == nil {
            arraySelectedFAQs = [Int]()
        }
        if let indexOf = arraySelectedFAQs?.firstIndex(of: indexPath.row) {
            arraySelectedFAQs.remove(at: indexOf)
        }
        else {
            arraySelectedFAQs.append(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
