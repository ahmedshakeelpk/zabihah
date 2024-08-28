//
//  FAQsListViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 28/08/2024.
//

import UIKit

class FAQsListViewController: UIViewController {
    
    

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
                imageViewNoAddressFound.isHidden = true
            }
            else {
                imageViewNoAddressFound.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FAQsListViewControllerCell.register(tableView: tableView)
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

    func navigateToFAQsViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.faqs.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FAQsViewController") as! FAQsViewController
        vc.fAQResponseModel = modelGetFAQsResponse?.faqResponseModel?[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension FAQsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetFAQsResponse?.faqResponseModel?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsListViewControllerCell") as! FAQsListViewControllerCell
        let modelFAQsData = modelGetFAQsResponse?.faqResponseModel?[indexPath.row]
        cell.labelQuestion.text = modelFAQsData?.category ?? ""
        cell.imageViewDropDown.image = UIImage(named: "forwardArrowGray")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
       
        navigateToFAQsViewController(index: indexPath.row)
        
//        if arraySelectedFAQs == nil {
//            arraySelectedFAQs = [Int]()
//        }
//        if let indexOf = arraySelectedFAQs?.firstIndex(of: indexPath.row) {
//            arraySelectedFAQs.remove(at: indexOf)
//        }
//        else {
//            arraySelectedFAQs.append(indexPath.row)
//        }
//        tableView.reloadRows(at: [indexPath], with: .none)
    }
}


extension FAQsListViewController {
    // MARK: - ModelGetFAQs
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
        let faqs: [FAQ]?
        let category: String?
    }

    // MARK: - FAQ
    struct FAQ: Codable {
        let answer, question: String?
    }
    
//    // MARK: - ModelGetFAQsResponse
//    struct ModelGetFAQsResponse: Codable {
//        let faqResponseModel: [FAQResponseModel]?
//        let totalPages: Int?
//        let success: Bool?
//        let message, innerExceptionMessage: String?
//        let token: String?
//        let totalFavorities: Int?
//        let recordFound: Bool?
//    }
//
//    // MARK: - FAQResponseModel
//    struct FAQResponseModel: Codable {
//        let answer, question: String?
//    }
}
