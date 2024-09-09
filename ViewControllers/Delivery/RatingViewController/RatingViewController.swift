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
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewBackGroundTitle: UIView!
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
    var modelGetRestaurantDetailResponse: HomeViewController.ModelRestuarantResponseData?
    var modelFeaturedResponse: HomeViewController.ModelFeaturedResponse? {
        didSet {
            if modelFeaturedResponse?.items?.count ?? 0 > 0 {
                if let reviews = modelFeaturedResponse?.items?[0]?.reviews {
                    modelReview = reviews
                }
            }
        }
    }

    var galleryRecentPhotos: [String?]?
    var isPrayerPlace: Bool = false
    var pageNumberForApi: Int! = 1 {
        didSet {
            DispatchQueue.main.async {
                if self.pageNumberForApi > 1 {
                    if self.pageNumberForApi > self.modelGetReview?.totalPages ?? 0 {
                        return()
                    }
                    self.getMyReviews()
                }
            }
        }
    }
    
    var modelGetReview: ModelGetReview? {
        didSet {
            modelReview = modelGetReview?.items
        }
    }
    var modelReview: [HomeViewController.Review?]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if let reviewDataObj = self.modelReview {
                    
                    let rating = self.calculateRatings(for: reviewDataObj)
                    self.labelRating.text = rating.1 ?? "0"
                    self.viewRatingCosmo.rating = Double(rating.1 ?? "0") ?? 0.0
                    self.labelReview.text = "\(reviewDataObj.count) reviews"
                    self.labelProgressOne.text = "\(rating.0[0])"
                    self.labelProgressTwo.text = "\(rating.0[1])"
                    self.labelProgressThree.text = "\(rating.0[2])"
                    self.labelProgressFour.text = "\(rating.0[3])"
                    self.labelProgressFive.text = "\(rating.0[4])"
                    
                    
                    self.progressBarOne.progress = (Float(rating.2[0]))/100
                    self.progressBarTwo.progress = (Float(rating.2[1]))/100
                    self.progressBarThree.progress = (Float(rating.2[2]))/100
                    self.progressBarFour.progress = (Float(rating.2[3]))/100
                    self.progressBarFive.progress = (Float(rating.2[4]))/100
                }
            }
        }
    }
    var pullControl = UIRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           pullControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
           tableView.addSubview(pullControl) // not
        tableView.refreshControl?.tintColor = .clear
    }
    @objc func pulledRefreshControl() {
        getMyReviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pullControl.endRefreshing()
        }
    }
    var stringTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RatingViewControllerCell.register(tableView: tableView)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        
        labelTitle.text = "Reviews of \(stringTitle)"
        
        resetTableView()
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
        resetTableView()
    }
    func resetTableView() {
        pageNumberForApi = 1
        modelGetReview = nil
        tableView.reloadData()
        if buttonZabiha.tag == 1 {
            getRestaurantDetail()
        }
        else {
            getMyReviews()
        }
    }
    @IBAction func buttonYelp(_ sender: Any) {
        return()
        viewLineZabiha.isHidden = true
        viewLineYelp.isHidden = false
        viewLineFromGoogle.isHidden = true
        buttonZabiha.tag = 0
        buttonYelp.tag = 1
        buttonFromGoogle.tag = 0
        resetTableView()
    }
    @IBAction func buttonFromGoogle(_ sender: Any) {
        viewLineZabiha.isHidden = true
        viewLineYelp.isHidden = true
        viewLineFromGoogle.isHidden = false
        buttonZabiha.tag = 0
        buttonYelp.tag = 0
        buttonFromGoogle.tag = 1
        resetTableView()
    }
    
    func navigateToAddAddressViewController(index: Int) {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
//        vc.galleryRecentPhotos = modelGetByType?.reviewDataObj?.reviewData?[index]?.images ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didSelectItemHandler(index: Int) {
        navigateToAddAddressViewController(index: index)
    }
    func navigateToWriteReviewViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        vc.isPrayerPlace = isPrayerPlace
//        vc.galleryRecentPhotos = galleryRecentPhotos
        vc.modelGetRestaurantDetailResponse = modelGetRestaurantDetailResponse
        vc.reviewPostedHandler = {
            self.reviewPostedHandler?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.resetTableView()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getMyReviews() {
        //        Available values : None, Restaurant, Mosque
        var parameters = [
            "type": isPrayerPlace ? "Mosque" : "Restaurant",
            "pageSize": "20",
            "page": "\(pageNumberForApi!)"
        ] as [String : String]
        
        if buttonFromGoogle.tag == 1 {
            parameters["placeId"] = modelGetRestaurantDetailResponse?.id ?? ""
        }
        
        APIs.getAPI(
            apiName:
                buttonZabiha.tag == 1 ? .getMyReview :
                buttonYelp.tag == 1 ? .getYelpReview :
                    .getGoogleReview,
            parameters: parameters,
            isPathParameters: false,
            methodType: .get,
            viewController: self
        ) { responseData, success, errorMsg, statusCode in
            var model: ModelGetReview? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                if self.pageNumberForApi > 1 {
                    if let record = self.modelGetReview?.items {
                        var oldModel = record
                        oldModel.append(contentsOf: model?.items ?? [])
                        model?.items = oldModel
                    }
                }
                self.modelGetReview = model
            }
        }
        
        //        let parameters = [
        //            "id": reviewDatum.id ?? "",
        //            "placeId": modelGetRestaurantDetailResponse?.id ?? "",
        //            "rating": viewStarCasmo.rating,
        //            "comment": textViewReview.text!,
        //            "willReturn": buttonRadioYes.tag == 1,
        //            "photoWebUrls": arrayAllUpLoadedPhotos
        //        ] as [String : Any]
    }
    
    func getRestaurantDetail() {
        var parameters = [String: Any]()
        let parts: [HomeViewController.PlacePart] = [.reviews]
        let featureRequestModel: HomeViewController.ModelFeaturedRequest = HomeViewController.ModelFeaturedRequest(
            ids: [modelGetRestaurantDetailResponse?.id ?? ""],
            rating: nil,
            page: nil,
            keyword: nil,
            pageSize: nil,
            cuisine: nil,
            meatHalalStatus: nil,
            alcoholPolicy: nil,
            parts: parts,
            orderBy: nil,
            sortOrder: nil,
            location: nil
        )
        do {
            let jsonData = try JSONEncoder().encode(featureRequestModel)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                parameters = jsonDict
            }
        } catch {
            print("Failed to convert model to dictionary: \(error)")
        }
        APIs.postAPI(apiName: isPrayerPlace ? .searchMosque : .searchRestaurant, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: HomeViewController.ModelFeaturedResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelFeaturedResponse = model
            }
        }
    }
    
    func didTapOnViewMoreOrViewLess(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .none)
    }
}

extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelReview?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingViewControllerCell") as! RatingViewControllerCell
        cell.index = indexPath.row
        cell.modelGetReviewData = modelReview?[indexPath.row]
        cell.galleryRecentPhotos = modelReview?[indexPath.row]?.photoWebUrls ?? []
        cell.didSelectItemHandler = didSelectItemHandler
        cell.didTapOnViewMoreOrViewLess = didTapOnViewMoreOrViewLess

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        
    }
    
    //Show Last Cell (for Table View)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if indexPath.row == ((modelGetByType?.reviewDataObj?.reviewData?.count ?? 0) - 1) {
//            print("came to last row")
//            pageNumberForApi += 1
//        }
        cell.layoutSubviews()
        cell.layoutIfNeeded()
    }
}

extension RatingViewController {
    // MARK: - ModelGetReview
    struct ModelGetReview: Codable {
        let currentPage, pageSize, totalRecords, totalPages: Int?
        let onFirstPage, onLastPage, hasNextPage, hasPreviousPage: Bool?
        var items: [HomeViewController.Review?]?
    }

//    // MARK: - Item
//    struct ModelGetReviewData: Codable {
//        let id, createdBy, createdOn, updatedBy: String?
//        let updatedOn: String?
//        let isDeleted: Bool?
//        let type: String?
//        let rating: Int?
//        let comment: String?
//        let willReturn: Bool?
//        let place: Place?
//        let user: User?
//        let photoWebUrls: [String?]?
//        let photos: [HomeViewController.Photos?]?
//        var photosGallery: [String?]? {
//            return photos?.map({ model in
//                model?.photoWebUrl
//            })
//        }
//    }

    // MARK: - Place
    struct Place: Codable {
        let id, name, address, iconImageWebURL: String?
    }

    // MARK: - User
    struct User: Codable {
        let id, firstName, lastName: String?
    }
}

extension RatingViewController {
    
    // Calculate the rating statistics with percentage
    func calculateRatings(for reviews: [HomeViewController.Review?]?) -> ([String], String?, [Double]) {
        var ratingCounts = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0]
        var totalRating = 0

        guard let reviews = reviews else {
            return ([String](), "", [Double]())
        }
        // Count the number of each rating
        for review in reviews {
            if let _ = ratingCounts[review?.rating ?? 0] {
                ratingCounts[review?.rating  ?? 0]! += 1
            }
            totalRating += review?.rating ?? 0
        }

        // Calculate total reviews
        let totalReviews = reviews.count

        // Calculate percentage for each rating
        func percentage(for count: Int, total: Int) -> Double {
            return total > 0 ? (Double(count) / Double(total)) * 100 : 0.0
        }

        let percent1Star = percentage(for: ratingCounts[1]!, total: totalReviews)
        let percent2Star = percentage(for: ratingCounts[2]!, total: totalReviews)
        let percent3Star = percentage(for: ratingCounts[3]!, total: totalReviews)
        let percent4Star = percentage(for: ratingCounts[4]!, total: totalReviews)
        let percent5Star = percentage(for: ratingCounts[5]!, total: totalReviews)
        
        let arrayforAllPercentagesIntValues = [
            percent1Star,
            percent2Star,
            percent3Star,
            percent4Star,
            percent5Star
        ]
        let arrayforAllPercentages = [
            "\(String(format: "%.0f", percent1Star))%",
            "\(String(format: "%.0f", percent2Star))%",
            "\(String(format: "%.0f", percent3Star))%",
            "\(String(format: "%.0f", percent4Star))%",
            "\(String(format: "%.0f", percent5Star))%"
        ]

        // Calculate the overall average rating
        let overallAverage = totalReviews > 0 ? Double(totalRating) / Double(totalReviews) : 0.0

        // Display rating percentages and overall average
        print("1-Star: \(String(format: "%.2f", percent1Star))%")
        print("2-Star: \(String(format: "%.2f", percent2Star))%")
        print("3-Star: \(String(format: "%.2f", percent3Star))%")
        print("4-Star: \(String(format: "%.2f", percent4Star))%")
        print("5-Star: \(String(format: "%.2f", percent5Star))%")
        print("Overall Average Rating: \(String(format: "%.2f", overallAverage))")
        
        return (arrayforAllPercentages, String(format: "%.2f", overallAverage), arrayforAllPercentagesIntValues)

    }
}

