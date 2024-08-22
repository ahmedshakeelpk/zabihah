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
    @IBOutlet weak var stackViewButtonTabBackGround: UIStackView!
    
    var selectedAddressIndex = 1
    var modelGetByUser: ModelGetByUser? {
        didSet {
            if modelGetByUser?.success ?? false {
                tableViewReloadData()
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelGetByUser?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    var modelDeleteReviewResponse: ModelDeleteReviewResponse! {
        didSet {
            if modelDeleteReviewResponse?.success ?? false {
                DispatchQueue.main.async {
                    self.getByUser()
                }
            }
            else {
                showAlertCustomPopup(title: "Error", message: modelDeleteReviewResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    func tableViewReloadData() {
        if modelGetByUser?.reviewDataObj?.reviewData?.count ?? 0 > 0 {
            imageViewNoDataFound.isHidden = true
        }
        else {
            imageViewNoDataFound.isHidden = false
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
        getByUser()
    }
    
    func setConfiguration() {
        viewTitle.radius(radius: 12)
        imageViewNoDataFound.isHidden = true
        ReviewsViewControllerCell.register(tableView: tableView)
        
        viewBottomLinePrayerSpaces.isHidden = true
        stackViewButtonTabBackGround.setShadow(radius: 6)
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        imageViewHalalFood.image = imageViewHalalFood.image?.withRenderingMode(.alwaysTemplate)
        imageViewMosque.image = imageViewMosque.image?.withRenderingMode(.alwaysTemplate)
        imageViewHalalFood.tintColor = .colorApp
        imageViewMosque.tintColor = .clrUnselectedImage
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
        getByUser()
    }
    @IBAction func buttonPrayerSpaces(_ sender: Any) {
        buttonHalalFood.tag = 0
        
        viewBottomLinePrayerSpaces.isHidden = false
        viewBottomLineHalalFood.isHidden = true
        imageViewHalalFood.tintColor = .clrUnselectedImage
        imageViewMosque.tintColor = .colorApp
        getByUser()
    }
    
    
    func getByUser() {
        let parameters: Parameters = [
            "type": buttonHalalFood.tag == 1 ? "rest" : "prayer",
            //              "reviewType": "",
            "page": 1,
            //              "pageSize": 0
        ]
        APIs.postAPI(apiName: .getbyuser, parameters: parameters, methodType: .post, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetByUser? = APIs.decodeDataToObject(data: responseData)
            self.modelGetByUser = model
        }
    }
    
    func buttonDeleteAddress(index: Int) {
        if let reviewData = modelGetByUser?.reviewDataObj?.reviewData?[index] {
            let id = reviewData.id ?? ""
            let url = "\(APIsName.name.deletereview.rawValue)"
            let parameters: Parameters = [
                "type": buttonHalalFood.tag == 1 ? "rest" : "prayer",
                "id": id,
            ]
            APIs.deleteAPI(apiName: url, parameters: parameters, methodType: .delete, viewController: self) { responseData, success, errorMsg in
                let model: ModelDeleteReviewResponse? = APIs.decodeDataToObject(data: responseData)
                self.modelDeleteReviewResponse = model
            }
        }
    }
    
    func buttonEditAddress(index: Int) {
        navigateToWriteReviewViewController(index: index)
    }
    
    func navigateToWriteReviewViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        vc.isFromEditReview = true
        vc.isPrayerPlace = buttonHalalFood.tag == 0
        if let reviewData = modelGetByUser?.reviewDataObj?.reviewData?[index] {
            vc.reviewDatum = reviewData
        }
        vc.reviewPostedHandler = {
            self.getByUser()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didSelectItemHandler(index: Int) {
        navigateToAddAddressViewController(index: index)
    }
    func navigateToAddAddressViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        if let reviewData = modelGetByUser?.reviewDataObj?.reviewData?[index] {
            vc.galleryRecentPhotos = reviewData.images
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetByUser?.reviewDataObj?.reviewData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsViewControllerCell") as! ReviewsViewControllerCell
        if let reviewData = modelGetByUser?.reviewDataObj?.reviewData?[indexPath.row] {
            cell.reviewDatum = reviewData
        }
        cell.index = indexPath.row
        cell.buttonEditHandler = buttonEditAddress
        cell.buttonDeleteHandler = buttonDeleteAddress
        cell.didSelectItemHandler = didSelectItemHandler
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        selectedAddressIndex = indexPath.row
        if let reviewData = modelGetByUser?.reviewDataObj?.reviewData?[indexPath.row] {
            
        }
    }
}


extension ReviewsViewController {
    // MARK: - ModelPostReview
    struct ModelGetByUser: Codable {
        let totalCounts: Int?
        let images: [String]?
        let reviewDataObj: ReviewDataObj?
        let totalPages: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        let recordFound: Bool?
    }
    
    // MARK: - ReviewDataObj
    struct ReviewDataObj: Codable {
        let top1, top5, top2: Int?
        let reviewData: [ReviewDatum?]?
        let totalReviews, top3: Int?
        let avgRating: Double?
        let top4: Int?
    }
    
    // MARK: - ReviewDatum
    struct ReviewDatum: Codable {
        let id: String?
        let rating: Double?
        let coverImage: String?
        let description: String?
        let period: String?
        let createdOn: String?
        let iconImage: String?
        let type: String?
        let userName: String?
        let address: String?
        let images: [String]?
        let returning: Bool?
        let name: String?
        let itemId: String?
    }
    
    
    // MARK: - ModelGetUserAddressResponse
    struct ModelDeleteReviewResponse: Codable {
        let success: Bool?
        let message: String?
        let recordFound: Bool?
        let innerExceptionMessage: String?
    }
}
