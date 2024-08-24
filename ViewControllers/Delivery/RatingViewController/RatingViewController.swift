//
//  RatingViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 20/08/2024.
//

import UIKit
import Cosmos
import Alamofire

class RatingViewController: UIViewController {
    
    @IBOutlet weak var viewButtonReviewBackGround: ViewButtonSetting!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelReview: UILabel!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var viewRatingCosmo: CosmosView!
    
    @IBOutlet weak var labelTitle: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var progressBarOne: UIProgressView!
    @IBOutlet weak var progressBarTwo: UIProgressView!
    @IBOutlet weak var progressBarThree: UIProgressView!
    @IBOutlet weak var progressBarFour: UIProgressView!
    @IBOutlet weak var progressBarFive: UIProgressView!
    @IBOutlet weak var labelProgressFive: UILabel!
    @IBOutlet weak var labelProgressFour: UILabel!
    @IBOutlet weak var labelProgressThree: UILabel!
    @IBOutlet weak var labelProgressTwo: UILabel!
    @IBOutlet weak var labelProgressOne: UILabel!
    @IBOutlet weak var buttonReview: UIButton!
    
    @IBOutlet weak var viewLineZabiha: UIView!
    @IBOutlet weak var viewLineYelp: UIView!
    @IBOutlet weak var viewLineFromGoogle: UIView!
    @IBOutlet weak var buttonZabiha: UIButton!
    @IBOutlet weak var buttonYelp: UIButton!
    @IBOutlet weak var buttonFromGoogle: UIButton!
    
    var reviewPostedHandler: (() -> ())!
    var modelGetRestaurantDetailResponse:  DeliveryDetailsViewController3.ModelGetRestaurantDetailResponse?
    var galleryRecentPhotos: [String]!
    var isPrayerPlace: Bool = false
    var pageNumberForApi: Int! = 1 {
        didSet {
            if pageNumberForApi > 1 {
                if pageNumberForApi > modelGetByType?.reviewDataObj?.totalReviews ?? 0 {
                    return()
                }
                getbytype()
            }
        }
    }
    var modelGetByType: ModelGetByType? {
        didSet {
            tableView.reloadData()
            
            if let reviewDataObj = modelGetByType?.reviewDataObj {
                viewRatingCosmo.rating = Double(reviewDataObj.avgRating ?? 0)
                labelReview.text = "\(reviewDataObj.totalReviews ?? 0) reviews"
                labelRating.text = "\(reviewDataObj.avgRating ?? 0)"
                labelProgressOne.text = "\(reviewDataObj.top1 ?? 0)%"
                labelProgressTwo.text = "\(reviewDataObj.top2 ?? 0)%"
                labelProgressThree.text = "\(reviewDataObj.top3 ?? 0)%"
                labelProgressFour.text = "\(reviewDataObj.top4 ?? 0)%"
                labelProgressFive.text = "\(reviewDataObj.top5 ?? 0)%"
                progressBarOne.progress = Float(modelGetByType?.reviewDataObj?.top1 ?? 0)
                progressBarTwo.progress = Float(modelGetByType?.reviewDataObj?.top2 ?? 0)
                progressBarThree.progress = Float(modelGetByType?.reviewDataObj?.top3 ?? 0)
                progressBarFour.progress = Float(modelGetByType?.reviewDataObj?.top4 ?? 0)
                progressBarFive.progress = Float(modelGetByType?.reviewDataObj?.top5 ?? 0)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RatingViewControllerCell.register(tableView: tableView)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        getbytype()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonReview(_ sender: Any) {
        navigateToWriteReviewViewController()
    }
    @IBAction func buttonZabiha(_ sender: Any) {
        viewLineZabiha.isHidden = false
        viewLineYelp.isHidden = true
        viewLineFromGoogle.isHidden = true
        buttonZabiha.tag = 1
        buttonYelp.tag = 0
        buttonFromGoogle.tag = 0
        pageNumberForApi = 1
        getbytype()
    }
    @IBAction func buttonYelp(_ sender: Any) {
        viewLineZabiha.isHidden = true
        viewLineYelp.isHidden = false
        viewLineFromGoogle.isHidden = true
        buttonZabiha.tag = 0
        buttonYelp.tag = 1
        buttonFromGoogle.tag = 0
        pageNumberForApi = 1
        getbytype()
    }
    @IBAction func buttonFromGoogle(_ sender: Any) {
        viewLineZabiha.isHidden = true
        viewLineYelp.isHidden = true
        viewLineFromGoogle.isHidden = false
        buttonZabiha.tag = 0
        buttonYelp.tag = 0
        buttonFromGoogle.tag = 1
        pageNumberForApi = 1
        getbytype()
    }
    
    func navigateToAddAddressViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.galleryRecentPhotos = modelGetByType?.reviewDataObj?.reviewData?[index]?.images ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapOnViewMoreHandler(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .bottom)
    }
    func didSelectItemHandler(index: Int) {
        navigateToAddAddressViewController(index: index)
    }
    func navigateToWriteReviewViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        vc.isPrayerPlace = isPrayerPlace
        vc.galleryRecentPhotos = galleryRecentPhotos
        vc.modelGetRestaurantDetailResponse = modelGetRestaurantDetailResponse
        vc.reviewPostedHandler = {
            self.reviewPostedHandler?()
            self.getbytype()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getbytype() {
        let parameters = [
            "id": modelGetRestaurantDetailResponse?.restuarantResponseData?.id ?? "",
            "type": isPrayerPlace ? "prayer" : "rest",
            "reviewType": buttonZabiha.tag == 1 ? "zabiha" : buttonYelp.tag == 1 ? "yelp" : "google",
            "page": pageNumberForApi!
        ] as [String : Any]
        
        APIs.postAPI(apiName: .getbytype, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            var model: ModelGetByType? = APIs.decodeDataToObject(data: responseData)
           
            if self.pageNumberForApi > 1 {
                if let record = self.modelGetByType?.reviewDataObj?.reviewData {
                    var oldModel = record
                    oldModel.append(contentsOf: model?.reviewDataObj?.reviewData ?? [])
                    model?.reviewDataObj?.reviewData = oldModel
                }
            }
            self.modelGetByType = model
        }
    }
}

extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelGetByType?.reviewDataObj?.reviewData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingViewControllerCell") as! RatingViewControllerCell
        cell.index = indexPath.row
        cell.reviewDatum = modelGetByType?.reviewDataObj?.reviewData?[indexPath.row]
        cell.galleryRecentPhotos = modelGetByType?.reviewDataObj?.reviewData?[indexPath.row]?.images ?? []
        cell.didSelectItemHandler = didSelectItemHandler
        cell.tapOnViewMoreHandler = tapOnViewMoreHandler
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        
    }
    
    //Show Last Cell (for Table View)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == ((modelGetByType?.reviewDataObj?.reviewData?.count ?? 0) - 1) {
            print("came to last row")
            pageNumberForApi += 1
        }
        cell.layoutSubviews()
        cell.layoutIfNeeded()
    }
}




extension RatingViewController {
    // MARK: - ModelGetByType
    // MARK: - ModelGetByType
    struct ModelGetByType: Codable {
        let totalCounts: Int?
        let images: [String]?
        var reviewDataObj: ReviewDataObj?
        let totalPages: Int?
        let success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        let recordFound: Bool?
    }
    
    // MARK: - ReviewDataObj
    struct ReviewDataObj: Codable {
        let top1, top5, top2: Int?
        var reviewData: [ReviewDatum?]?
        let totalReviews, top3: Int?
        let avgRating: Double?
        let top4: Int?
    }
    
    // MARK: - ReviewDatum
    struct ReviewDatum: Codable {
        let id: String
        let rating: Double?
        let coverImage: String?
        let description, period: String?
        let createdOn: String?
        let iconImage: String?
        let type, userName: String?
        let address: String?
        let images: [String]?
        let returning: Bool?
        let name: String?
        let itemId: String?
    }
}
