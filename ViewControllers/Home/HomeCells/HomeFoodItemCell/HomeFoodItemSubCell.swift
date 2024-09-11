//
//  HomeFoodItemCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

protocol HomeFoodItemSubCellDelegate: AnyObject {
    func changeFavouriteStatus(isFavourite: Bool, indexPath: IndexPath, cellType: UICollectionViewCell)
}

extension HomeFoodItemSubCell {
    struct ModelPostFavouriteRestaurantsResponse: Codable {
        let createdOn: String?
        let updatedBy, id: String?
        let updatedOn: String?
        let isDeleted: Bool?
        let createdBy: String?
    }
}
class HomeFoodItemSubCell: UICollectionViewCell {
    @IBOutlet weak var stackViewReturning: UIStackView!
    @IBOutlet weak var stackViewPhotos: UIStackView!
    @IBOutlet weak var stackViewComments: UIStackView!
    
    @IBOutlet weak var stackViewFavouriteBackGround: UIStackView!
    @IBOutlet weak var buttonOpenDirectionMap: UIButton!
    @IBOutlet weak var buttonCall: UIView!
    
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRestaurantAddress: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelReuse: UILabel!
    @IBOutlet weak var labelPictures: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var viewItemTypeBackGround: UIView!
    @IBOutlet weak var labelItemType: UILabel!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewCallMainBackGround: UIView!
    @IBOutlet weak var viewBikeBackGround: UIView!
    @IBOutlet weak var viewCallBackGround: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewRatingBackGround: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var viewBackGroundDelivery: UIView!
    
    var delegate: HomeFoodItemSubCellDelegate!
    var buttonFavouriteHandler: (() -> ())!
    var viewController = UIViewController()
    var indexPath: IndexPath! = nil
    var arrayNames = [String]()
    //    var isFavourite = false

    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            if let isFavourite = self.restuarentResponseModel?.isMyFavorite {
                DispatchQueue.main.async {
                    self.delegate?.changeFavouriteStatus(isFavourite: !isFavourite, indexPath: self.indexPath, cellType: HomeFoodItemSubCell())
                }
                restuarentResponseModel.isMyFavorite = !(isFavourite)
            }
        }
    }
    
    var restuarentResponseModel: HomeViewController.ModelRestuarantResponseData! {
        didSet {
            DispatchQueue.main.async {
                self.setData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewBackGround.radius(radius: 12)
        viewBikeBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewCallBackGround.radius(radius: 6, color: .clrLightGray, borderWidth: 1)
        viewRatingBackGround.radius(radius: 4)
        viewItemTypeBackGround.circle()
        HomeFoodItemSubCuisineCell.register(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imageViewRestaurant.circle()
        
        setData()
    }
    
    @IBAction func buttonOpenDirectionMap(_ sender: Any) {
        OpenMapDirections.present(in: viewController, sourceView: buttonOpenDirectionMap, latitude: restuarentResponseModel?.latitude ?? 0, longitude: restuarentResponseModel?.longitude ?? 0, locationName: restuarentResponseModel?.address ?? "")
    }
    @IBAction func buttonCall(_ sender: Any) {
        self.viewController.dialNumber(number: restuarentResponseModel?.phone ?? "")
    }
    @IBAction func buttonFavourite(_ sender: Any) {
        delegate = viewController as? any HomeFoodItemSubCellDelegate
        favouriteRestaurants()
    }
    
    func setData() {
        labelRestaurantName.text = restuarentResponseModel?.name
        labelRestaurantAddress.text = restuarentResponseModel?.address
        labelRating.text = getRating(averageRating: restuarentResponseModel?.averageRating)
        
        labelReuse.text = getRatingEnum(averageRating: restuarentResponseModel?.willReturnPercentage) + "%"
        stackViewReturning.isHidden = getRatingEnum(averageRating: restuarentResponseModel?.willReturnPercentage) == "0"
        
        labelComments.text = "\(restuarentResponseModel?.totalReviews ?? 0)"
        stackViewComments.isHidden = (restuarentResponseModel?.totalPhotos ?? 0) == 0
        
        labelPictures.text = "\(restuarentResponseModel?.totalPhotos ?? 0)"
        stackViewPhotos.isHidden = (restuarentResponseModel?.totalPhotos ?? 0) == 0

        labelDistance.text = "\(oneDecimalDistance(distance:restuarentResponseModel?.distance))"
        //        labelDistance.text = "\(oneDecimalDistance(distance:modelFeaturedRestuarantResponseData?.distance))\(modelFeaturedRestuarantResponseData?.distance?.unit ?? "")"
        imageViewRestaurant.setImage(urlString: restuarentResponseModel?.iconImageWebUrl ?? "", placeHolderIcon: "placeHolderRestaurant")
        imageViewItem.setImage(urlString: restuarentResponseModel?.coverImageWebUrl ?? "", placeHolderIcon: "placeHolderFoodItem")
        imageViewFavourite.image = UIImage(named: restuarentResponseModel?.isMyFavorite ?? false ? "heartFavourite" : "heartUnFavourite")
        viewCallMainBackGround.isHidden = restuarentResponseModel?.phone ?? "" == ""
//        stackViewFavouriteBackGround.isHidden = !(restuarentResponseModel?.isMyFavorite ?? false)
        
        if let cuisines = restuarentResponseModel?.cuisines {
            let filteredCuisines = cuisines.compactMap { $0?.name }.filter { !$0.isEmpty }
            arrayNames = filteredCuisines
            collectionView.reloadData()
        }
        viewBackGroundDelivery.isHidden = !(restuarentResponseModel?.offersDelivery ?? false)
        
        if indexPath?.section == 0 {
            viewItemTypeBackGround.isHidden = false
            labelItemType.text = "Order Now"
            viewItemTypeBackGround.backgroundColor = .colorRed
        }
        else {
            let isNewRestaurent = ifNewRestaurent(createdOn: restuarentResponseModel?.createdOn ?? "")
            viewItemTypeBackGround.isHidden = isNewRestaurent == ""
            labelItemType.text = isNewRestaurent
            viewItemTypeBackGround.backgroundColor = .colorGreen
            
            
            let isClose = !isRestaurantOpen(timings: restuarentResponseModel?.timings ?? []).0
            if isClose {
                //                viewItemTypeBackGround.isHidden = !isClose
                //                labelItemType.text = "Close"
                //                viewItemTypeBackGround.backgroundColor = .colorRed
            }
            //            viewItemTypeBackGround.backgroundColor = .colorOrange
        }
        viewItemTypeBackGround.isHidden = true
    }
    
    func favouriteRestaurants() {
        let parameters = [
            "placeId": restuarentResponseModel.id ?? ""
        ]
//        Awais user token
//        kAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWQiOiJhZTBhYTZlNS0yNWMwLTQ4Y2ItOTgzMy1jYWU3MGI2NGVmY2QiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiIwYzhhNjMyYy1iNmY1LTRkOTgtOTBiNS04YmNkMmJhNGQ1MjkiLCJuYmYiOjE3MjU1MTEwOTYsImV4cCI6MTcyODEwMzA5NiwiaXNzIjoiaHR0cHM6Ly96YWJpaGFoLmNvbS8iLCJhdWQiOiJodHRwczovL3phYmloYWguY29tLyJ9.gWg4g1NHAVem1GIBDFWxLTWKPDP1TTIV5gERXh8FEsk"

        APIs.getAPI(apiName: restuarentResponseModel?.isMyFavorite ?? false == true ? .favouriteDelete : .favourite, parameters: parameters, isPathParameters: true, methodType: restuarentResponseModel?.isMyFavorite ?? false == true ? .delete : .post, viewController: viewController) { responseData, success, errorMsg, statusCode in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostFavouriteRestaurantsResponse = model
            }
        }
    }
}

extension HomeFoodItemSubCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 20
        return CGSize(width: width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodItemSubCuisineCell", for: indexPath) as! HomeFoodItemSubCuisineCell
        cell.labelName.text = arrayNames[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //            DispatchQueue.main.async {
        //                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        //            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        collectionView.reloadData()
    }
}
func getRating(averageRating: HomeViewController.Rating?) -> String {
    if let rating = averageRating {
        switch rating {
        case .int(let intValue):
            return intValue == 0 ? "--" : "\(intValue)"
        case .double(let doubleValue):
            return doubleValue == 0 ? "--" : String(format: "%.1f", doubleValue)
              // or "\(doubleValue)" if you want the full double
        case .string(let stringValue):
            return stringValue
        case .none:
            return "--"
        }
    } else {
        return "--"
    }
}

func getRatingEnum(averageRating: HomeViewController.Rating?) -> String {
    if let rating = averageRating {
        switch rating {
        case .int(let intValue):
            return "\(intValue)"
        case .double(let doubleValue):
            return String(format: "%.1f", doubleValue)
              // or "\(doubleValue)" if you want the full double
        case .string(let stringValue):
            return stringValue
        case .none:
            return "0"
        }
    } else {
        return "0"
    }
}

func oneDecimalDistance(distance: HomeViewController.Distance?) -> String {
    if let distance = distance?.distance {
        let distanceInMeters: Double = distance  // Example distance in meters
        let distanceInKilometers = distanceInMeters / 1000
        let distanceInKilometersFormatted = String(format: "%.2f", distanceInKilometers)
        return "\(distanceInKilometersFormatted) km"
    } else {
        print("0.00") // or labelDistance.text = "0.00"
        return "0"
    }
}

func ifNewRestaurent(createdOn: String) -> String {
    let createdOnString = createdOn //"2024-08-28T14:20:00Z" // Example ISO 8601 date string
    let dateFormatter = ISO8601DateFormatter() // Using ISO8601 format for the date
    if let createdOnDate = dateFormatter.date(from: createdOnString) {
        // Get the current date
        let currentDate = Date()
        
        // Calculate the difference in days
        let calendar = Calendar.current
        let dateDifference = calendar.dateComponents([.day], from: createdOnDate, to: currentDate)
        
        if let daysPassed = dateDifference.day {
            if daysPassed < 30 {
                print("NEW")
                return "NEW"
            } else {
                print("Days passed: \(daysPassed) days")
                return ""
            }
        }
    } else {
        print("Invalid date format")
        
    }
    return ""
}

// Function to check if the restaurant is open
func isRestaurantOpen(timings: [HomeViewController.Timing?]?) -> (Bool, HomeViewController.Timing?) {
    // Get the current day and time
    let currentDate = Date()
    let calendar = Calendar.current
    
    // Get the current day of the week as a string (e.g., Monday, Tuesday)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let currentDayOfWeek = dateFormatter.string(from: currentDate)
    
    // Find the opening and closing times for the current day
    guard let todayTiming = timings?.first(where: { $0?.dayOfWeek == currentDayOfWeek }) else {
        return (false, nil) // If no matching day is found, return closed
    }
    
    // Create DateFormatter for time comparison
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss"
    
    // Parse the opening and closing times
    guard let openingTime = timeFormatter.date(from: todayTiming?.openingTime ?? ""),
          let closingTime = timeFormatter.date(from: todayTiming?.closingTime ?? "") else {
        return (false, todayTiming)
    }
    
    // Get the current time as a Date object
    let currentTime = timeFormatter.date(from: timeFormatter.string(from: currentDate))!
    
    // Check if the current time is within the opening and closing times
    return (currentTime >= openingTime && currentTime <= closingTime, todayTiming)
}

func getAllUniqueCuisines(items: [HomeViewController.ModelRestuarantResponseData?]?) -> [ HomeViewController.ModelCuisine] {
    if let items = items {
        // Flatten the cuisines arrays into a single array
        let allCuisines = items.compactMap { $0?.cuisines }.flatMap { $0 }

        // Use a Set to filter out duplicate cuisines based on name
        let uniqueCuisines = Array(Set(allCuisines.compactMap { $0 }.filter { $0.name != nil }))
        
        // Return unique cuisines
        return uniqueCuisines
    } else {
        print("No items available")
        return [] // Return an empty array if no items are available
    }
}



import Foundation

func timeAgo(from dateString: String) -> String {
    // Define the date formatter
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime]
    
    // Convert the string to a Date object
    guard let date = dateFormatter.date(from: dateString) else {
        return "Invalid date"
    }
    
    // Calculate the time interval from now
    let timeInterval = Date().timeIntervalSince(date)
    
    // Use DateComponentsFormatter to calculate the time difference
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
    formatter.maximumUnitCount = 1  // Show only the largest unit
    
    // Return the formatted time difference as a string
    return formatter.string(from: timeInterval) ?? "Just now"
}
