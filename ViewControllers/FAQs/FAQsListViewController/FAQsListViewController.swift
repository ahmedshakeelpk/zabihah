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
    var uniqueCategoriesArray = [String]()
    var modelGetFAQsResponse: [ModelGetFAQsResponse?]? {
        didSet {
            DispatchQueue.main.async {
                if let faqs = self.modelGetFAQsResponse, faqs.count > 0 {
                    self.imageViewNoAddressFound.isHidden = true
                    
                    // Get unique categories
                    let uniqueCategoriesSet = Set(faqs.compactMap { $0?.category }) // Unwrap and collect non-nil categories
                    
                    // Convert to an array if needed
                    self.uniqueCategoriesArray = Array(uniqueCategoriesSet)
                }
                else {
                    self.imageViewNoAddressFound.isHidden = false
                }
                
                self.tableView.reloadData()
            }
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
        APIs.postAPI(apiName: .faq, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode  in
            let model: [ModelGetFAQsResponse?]? = APIs.decodeDataToObject(data: responseData)
            self.modelGetFAQsResponse = model
        }
    }

    func navigateToFAQsViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.faqs.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FAQsViewController") as! FAQsViewController
        let category = uniqueCategoriesArray[index]
        let generalCategoryModels = getModels(withCategory:category, from: modelGetFAQsResponse!)
        vc.fAQResponseModel = generalCategoryModels
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Function to get all models with the same category
    func getModels(withCategory category: String, from models: [ModelGetFAQsResponse?]?) -> [ModelGetFAQsResponse] {
        return models?.filter { $0?.category == category } as! [FAQsListViewController.ModelGetFAQsResponse]
    }
}


extension FAQsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueCategoriesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsListViewControllerCell") as! FAQsListViewControllerCell
        let category = uniqueCategoriesArray[indexPath.row]
        cell.labelQuestion.text = category
        cell.imageViewDropDown.image = UIImage(named: "forwardArrowGray")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
       
        navigateToFAQsViewController(index: indexPath.row)
    }
}


extension FAQsListViewController {
    // MARK: - ModelGetFAQs
    struct ModelGetFAQsResponse: Codable {
        let category: String?
        let answer: String?
        let isDeleted: Bool?
        let id, question: String?
        let createdOn: String?
        let createdBy, updatedBy: String?
        let updatedOn: String?
    }
}
