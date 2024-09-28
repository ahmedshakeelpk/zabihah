//
//  DeliveryDetailsViewController3.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 28/07/2024.
//

import UIKit
import CoreLocation
import MessageUI

protocol DeliveryDetailsViewController3Delegate: AnyObject {
    func changeFavouriteStatusFromDetails(isFavourite: Bool, indexPath: IndexPath)
}

class DeliveryDetailsViewController3: UIViewController {
    @IBOutlet weak var viewRatingBackGround: ViewRadius6!
    @IBOutlet weak var viewReturningBackGround: ViewRadius6!
    @IBOutlet weak var viewReviewBackGround: ViewRadius6!
    @IBOutlet weak var viewAlcoholBackGround: ViewRadius6!
    
    
    
    
    @IBOutlet weak var viewCuisinesBackGround: UIView!
    @IBOutlet weak var viewHalalSummaryBackGround: UIView!
    @IBOutlet weak var viewHalalMenuBackGround: UIView!
    @IBOutlet weak var viewAmenitiesBackGround: UIView!
    @IBOutlet weak var stackViewConnectBackGround: UIStackView!
    @IBOutlet weak var viewFavouriteBackGround: UIView!
    
    @IBOutlet weak var imageViewRestaurantIcon: UIImageView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelDistanceAway: UILabel!
    @IBOutlet weak var collectionViewRecentPhoto: UICollectionView!
    @IBOutlet weak var collectionViewConnect: UICollectionView!
    @IBOutlet weak var buttonBack: UIView!
    @IBOutlet weak var collectionViewCuisines: UICollectionView!
    @IBOutlet weak var collectionViewType: UICollectionView!
    @IBOutlet weak var collectionViewFoodItem: UICollectionView!
    @IBOutlet weak var buttonRating: UIButton!
    @IBOutlet weak var buttonOpenDirectionMap: UIButton!
    @IBOutlet weak var labelConnectWith: UILabel!
    
    @IBOutlet weak var labelRestaurantDetails: UILabel!
    @IBOutlet weak var buttonAmenities: UIButton!
    @IBOutlet weak var buttonHalalSummary: UIButton!
    @IBOutlet weak var labelHalalSummaryDetails: UILabel!
    @IBOutlet weak var viewShareBackGround: UIView!
    @IBOutlet weak var viewCallBackGround: UIView!
    @IBOutlet weak var buttonTiming: UIButton!
    
    @IBOutlet weak var imageViewHalalSummaryDropDown: UIImageView!
    @IBOutlet weak var labelFullHalalMenu: UILabel!
    @IBOutlet weak var labelAlcohol: UILabel!
    @IBOutlet weak var labelCloseOpen: UILabel!
    @IBOutlet weak var labelReviews: UILabel!
    @IBOutlet weak var labelReturning: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var viewHalalSummaryDetailsBackGround: UIView!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    
    @IBOutlet weak var tileWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var tileWidthConstrant2ndTiles: NSLayoutConstraint!
    var delegate: DeliveryDetailsViewController3Delegate!
    var arrayLocalGallery: [UIImage]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewRecentPhoto.reloadData()
            }
        }
    }
    var isPrayerPlace: Bool = false
    var arrayNames = [String]()
    var userLocation: CLLocation!
    var modelRestuarantResponseData: HomeViewController.ModelRestuarantResponseData!
    var selectedMenuCell: Int!
    var indexPath: IndexPath!
    var isFeaturedCell: Bool! = false
    var isFromFavouriteScreen = false
    
    var modelFeaturedResponse: HomeViewController.ModelFeaturedResponse? {
        didSet {
            DispatchQueue.main.async {
                self.setData()
            }
        }
    }
    var galleryRecentPhotos: [String?]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewRecentPhoto.reloadData()
            }
        }
    }
    var connectSocial: [HomeViewController.WebLink?]? {
        didSet {
            collectionViewConnect.reloadData()
        }
    }
    var timingOpenClose: [HomeViewController.Timing?]? {
        didSet {
            
        }
    }
    var amenitiesData: [HomeViewController.Amenity?]? {
        didSet {
            
        }
    }
    
    var modelPostFavouriteDeleteResponse: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? {
        didSet {
            print(modelPostFavouriteDeleteResponse as Any)
            if let isFavourite = self.modelFeaturedResponse?.items?.first??.isMyFavorite {
                DispatchQueue.main.async {
                    self.delegate.changeFavouriteStatusFromDetails(isFavourite: !isFavourite, indexPath: self.indexPath)
                }
                modelFeaturedResponse?.items?[0]?.isMyFavorite = !isFavourite
            }
        }
    }
    var modelGetBlobToken: ModelGetBlobToken? {
        didSet{
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let width = (self.view.frame.width - 40) / 3
        tileWidthConstrant.constant = width
        tileWidthConstrant2ndTiles.constant = width
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        isPrayerPlace = modelRestuarantResponseData.type ?? "" != "rest"
        setConfiguration()
        getRestaurantDetail()
        enableSwipeToPop()
        getBlobToken()
    }
    
    @IBAction func buttonFavourite(_ sender: Any) {
        favouriteRestaurants()
    }
    @IBAction func buttonCall(_ sender: Any) {
        dialNumber(isPrayerPlaces: isPrayerPlace, name: "", number: modelFeaturedResponse?.items?[0]?.phone ?? "")
    }
    
    @IBAction func buttonShare(_ sender: Any) {
        let shareLink = getShareLink()
//        if shareLink.isEmpty {
//            return
//        }
        let text = getShareDate()
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getShareDate() -> String {
        if let restuarantResponseData = modelFeaturedResponse?.items?.first {
            let shareLink = getShareLink()
            let textData = "I wanted to let you know about this halal restaurant on Zabihah \n\n\n \(restuarantResponseData?.name ?? "")\n\(restuarantResponseData?.address ?? "")\n\(restuarantResponseData?.city ?? ""), \(restuarantResponseData?.state ?? "") \(restuarantResponseData?.zip ?? "")\n\(restuarantResponseData?.phone ?? "")\n\(shareLink)\n\n\(restuarantResponseData?.description ?? "")\n\n\(restuarantResponseData?.halalDescription ?? "")"
            return textData
        }
        
        return  getShareLink()
    }
    
    func getShareLink() -> String {
        if let websiteLinks = modelFeaturedResponse?.items?[0]?.webLinks?.compactMap({ model in
            // Check if the type is "Website" (case-insensitive)
            return model?.type?.lowercased() == "website" ? model : nil
        }) {
            // You now have an array of models where type is "Website"
            return  websiteLinks.first?.value ?? ""
        }
        return ""
    }
    
    @IBAction func buttonRating(_ sender: Any) {
        navigateToRatingViewController()
    }
    @IBAction func buttonTiming(_ sender: Any) {
        navigateToDeliveryBottomSheet()
    }
    @IBAction func buttonAmenities(_ sender: Any) {
        navigateToDeliveryBottomSheet(isAmenities: true)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
    }
    @IBAction func buttonHalalSummary(_ sender: Any) {
        buttonHalalSummary.tag = buttonHalalSummary.tag == 0 ? 1 : 0
        viewHalalSummaryDetailsBackGround.isHidden = buttonHalalSummary.tag == 0
        let imageName = buttonHalalSummary.tag == 0 ? "downArrowGray" : "upArrowGray"
        self.imageViewHalalSummaryDropDown.image = nil
        DispatchQueue.main.async {
            self.imageViewHalalSummaryDropDown.image = UIImage(named: imageName)
        }
    }
    
    func setConfiguration() {
        imageViewRestaurantIcon.circle()
        HomeFoodItemSubCuisineCell.register(collectionView: collectionViewCuisines)
        RecentPhotoCell.register(collectionView: collectionViewRecentPhoto)
        UpLoadPhotoCell.register(collectionView: collectionViewRecentPhoto)
        SocialConnectCell.register(collectionView: collectionViewConnect)
        
        //        viewFavouriteBackGround.isHidden = isFeaturedCell
        collectionViewCuisines.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        collectionViewRecentPhoto.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        collectionViewConnect.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
    }
    func setData() {
        if let restuarantResponseData = modelFeaturedResponse?.items?.first {
            labelRestaurantName.text = restuarantResponseData?.name ?? ""
            labelConnectWith.text = "Connect with \(restuarantResponseData?.name ?? "")"
            labelAddress.text = "\(restuarantResponseData?.address ?? ""), \(restuarantResponseData?.secondaryAddress ?? "")\n\(restuarantResponseData?.city ?? ""), \(restuarantResponseData?.state ?? "") \(restuarantResponseData?.zip ?? "")"
            
            labelDistanceAway.text = "\(oneDecimalDistance(distance:restuarantResponseData?.distance)) away"
            
            imageViewRestaurantIcon.setImage(urlString: restuarantResponseData?.iconImageWebUrl ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque2" : "placeHolderFoodItem2")
            
            labelRestaurantDetails?.text = restuarantResponseData?.description
            if labelRestaurantDetails.linesCount() > 3 {
                setLabelTextInThreeLine(text: restuarantResponseData?.description ?? "", label: labelRestaurantDetails)
            }
            labelHalalSummaryDetails.text = restuarantResponseData?.halalDescription
            viewHalalSummaryBackGround.isHidden = restuarantResponseData?.halalDescription ?? "" == ""
            viewHalalMenuBackGround.isHidden = isPrayerPlace
            
            
            let halalStatus = (restuarantResponseData?.meatHalalStatus ?? "").lowercased()
            let halal = (halalStatus == "full") ? "Full halal menu"
            :
            (halalStatus == "partial") ? "Partial halal menu"
            :
            "Halal unknown"
            labelFullHalalMenu.text = halal
            
            
            let alcoholPolicy = (restuarantResponseData?.alcoholPolicy ?? "").lowercased()
            let alcohol = (alcoholPolicy == "NotAllowed".lowercased()) ? "No alcohol"
            :
            (alcoholPolicy == "Served".lowercased()) ? "Alcohol served"
            :
            "Alcohol allowed"
            labelAlcohol.text = alcohol
            
            let restaurantTiming = isRestaurantOpen(timings: restuarantResponseData?.timings ?? [])
            if restaurantTiming.1 != nil {
                let isClose = !(restaurantTiming.0)
                let openOrCloseString = isClose ? "Opens at" : "Closes at"
                let openOrCloseTime = isClose ? (restaurantTiming.1?.openingTime ?? "") : (restaurantTiming.1?.closingTime ?? "")
                let openOrCloseTimeWith12HourFormat = is12HourFormat ? (openOrCloseTime).time12String : (openOrCloseTime).time24String
                labelCloseOpen.text = "\(openOrCloseString) \(openOrCloseTimeWith12HourFormat)"
            }
//            viewShareBackGround.isHidden = getShareLink() == ""
            
            imageViewFavourite.image = UIImage(named: restuarantResponseData?.isMyFavorite ?? false ? "heartFavourite" : "heartMehroon")
            
            let review = restuarantResponseData?.totalReviews ?? 0
            let reviews = (review == 1) ? "\(review) review"
            :
            (review > 1) ? "\(review) reviews"
            :
            "No reviews"
            labelReviews.text = reviews
            
//            viewReviewBackGround.isHidden = restuarantResponseData?.totalReviews ?? 0 == 0
            
            let reviewCount = getRatingEnum(averageRating: restuarantResponseData?.willReturnPercentage)
            labelReturning.text = "\(reviewCount)% returning"
            viewReturningBackGround.isHidden = reviewCount == "0"
            
            
            let rating = getRating(averageRating: restuarantResponseData?.averageRating) == "--" ? "No" : getRating(averageRating: restuarantResponseData?.averageRating)
            labelRating.text = "\(rating) rating"
            
            viewCallBackGround.isHidden = restuarantResponseData?.phone ?? "" == ""
            viewCuisinesBackGround.isHidden = restuarantResponseData?.cuisines == nil || restuarantResponseData?.cuisines == []
            
            if let cuisines = restuarantResponseData?.cuisines {
                let filteredCuisines = cuisines.compactMap { $0?.name }.filter { !$0.isEmpty }
                arrayNames = filteredCuisines
                collectionViewCuisines.reloadData()
            }
            
            if let timing = restuarantResponseData?.timings, timing.count > 0 {
                timingOpenClose = timing
            }
            if let amenities = restuarantResponseData?.amenities, amenities.count > 0 {
                amenitiesData = amenities
                viewAmenitiesBackGround.isHidden = false
            }
            else {
                viewAmenitiesBackGround.isHidden = true
            }
            if let photos = restuarantResponseData?.photosGallery, photos.count > 0 {
                let sortedGalleryPhotos = photos
                    .compactMap { $0 } // Remove nil values
                    .sorted(by: >)     // Sort in descending order
                
                galleryRecentPhotos = sortedGalleryPhotos
            }
            
            if let connect = restuarantResponseData?.webLinks, connect.count > 0 {
                connectSocial = connect
                stackViewConnectBackGround.isHidden = false
            }
            else {
                stackViewConnectBackGround.isHidden = true
            }
        }
    }
    
    func navigateToDeliveryBottomSheet(isAmenities: Bool? = false) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryBottomSheet") as! DeliveryBottomSheet
        vc.timingOpenClose = timingOpenClose
        vc.amenitiesData = amenitiesData
        vc.isAmenities = isAmenities
        self.present(vc, animated: true)
    }
    func navigateToRatingViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        vc.stringTitle = labelRestaurantName.text!
        vc.galleryRecentPhotos = self.galleryRecentPhotos
        if modelFeaturedResponse?.items?.count ?? 0 > 0 {
            vc.modelGetRestaurantDetailResponse = modelFeaturedResponse?.items?[0]
        }
        vc.isPrayerPlace = isPrayerPlace
        vc.reviewPostedHandler = {
            self.getRestaurantDetail()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func favouriteRestaurants() {
        let parameters = [
            "placeId": modelFeaturedResponse?.items?.first??.id ?? ""
        ]
        APIs.getAPI(apiName: modelFeaturedResponse?.items?.first??.isMyFavorite ?? false == true ? .favouriteDelete : .favourite, parameters: parameters, isPathParameters: true, methodType: modelFeaturedResponse?.items?.first??.isMyFavorite ?? false == true ? .delete : .post, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostFavouriteRestaurantsResponse = model
            }
        }
    }
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
            print(modelPostFavouriteDeleteResponse as Any)
            if let isFavourite = self.modelFeaturedResponse?.items?.first??.isMyFavorite {
                
                DispatchQueue.main.async {
                    self.modelFeaturedResponse?.items?[0]?.isMyFavorite = !isFavourite
//                    self.delegate?.changeFavouriteStatusFromDetails(isFavourite: !isFavourite, indexPath: self.indexPath)
                }
                modelFeaturedResponse?.items?[0]?.isMyFavorite = !isFavourite
            }
        }
    }
    
    func configuredMailComposeViewController(email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.showAlertCustomPopup(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", iconName: .iconError)
    }
    
    @IBAction func buttonOpenDirectionMap(_ sender: Any) {
        let completeAddress = "\(modelFeaturedResponse?.items?.first??.name ?? "") \(modelFeaturedResponse?.items?.first??.address ?? "") \(modelFeaturedResponse?.items?.first??.city ?? "") \(modelFeaturedResponse?.items?.first??.state ?? "") \(modelFeaturedResponse?.items?.first??.country ?? "")"
        OpenMapDirections.present(in: self, sourceView: buttonOpenDirectionMap, latitude: modelFeaturedResponse?.items?.first??.latitude ?? 0, longitude: modelFeaturedResponse?.items?.first??.longitude ?? 0, locationAddress: completeAddress)
    }
    
    func setLabelTextInThreeLine(text: String, label: UILabel) {
        label.numberOfLines = 3
        let fullText = text
        let ellipsisText = "… "
        let moreText = "more"

        // Truncate the text to a maximum length, considering ellipsis and "more"
        let maxLength = 120
        let truncatedText = (fullText as NSString).substring(with: NSRange(location: 0, length: min(fullText.count, maxLength)))

        // Create attributed string with truncated text
        let attributedString = NSMutableAttributedString(string: truncatedText)

        // Create attributed string for the "…" part (no underline)
        let ellipsisAttributedString = NSAttributedString(string: ellipsisText)

        // Create attributed string for the "more" text with underline
        let moreAttributedString = NSMutableAttributedString(
            string: moreText,
            attributes: [
                .foregroundColor: UIColor.colorApp, // Custom color
                .font: UIFont.systemFont(ofSize: 12, weight: .bold),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        // Append the "…" and "more" attributed strings to the truncated text
        attributedString.append(ellipsisAttributedString)
        attributedString.append(moreAttributedString)

        // Set the final attributed text to the label
        label.attributedText = attributedString

        // Enable user interaction for tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewMoreTapped(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewMoreTapped(_ sender: UITapGestureRecognizer) {
        // Retrieve the associated text
        if let restuarantResponseData = modelFeaturedResponse?.items?.first {
            print("More tapped with text: \(restuarantResponseData?.description ?? "")")
            
            // Expanding the label and setting the full text
            labelRestaurantDetails.numberOfLines = 0
            labelRestaurantDetails.text = restuarantResponseData?.description ?? ""
        }
    }
}


extension DeliveryDetailsViewController3: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: collectionViewFoodItem == collectionView ? 0 : 8, bottom: 0, right: collectionViewFoodItem == collectionView ? 0 : 12 )
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionViewCuisines == collectionView) {
            let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 22
            return CGSize(width: width, height: (collectionViewCuisines == collectionView) ? 22 : 28)
        }
        else if (collectionViewType == collectionView) {
            let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 22
            return CGSize(width: width, height: (collectionViewCuisines == collectionView) ? 22 : 28)
        }
        else if (collectionViewRecentPhoto == collectionView) {
//            let width = collectionView.frame.width / 3.4
            return CGSize(width: 90, height: 90)
        }
        else if (collectionViewConnect == collectionView) {
//            let width = collectionView.frame.width / 3.4
            return CGSize(width: 65, height: 65)
        }
        else {
            let width = collectionView.frame.width / 2 - 8
            return CGSize(width: width, height: 240)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewRecentPhoto {
            return 3
        }
        else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewConnect:
            return connectSocial?.count ?? 0
        case collectionViewCuisines:
            return arrayNames.count
        case collectionViewRecentPhoto:
            if section == 0 {
                return 1
            }
            else if section == 1 {
                return arrayLocalGallery?.count ?? 0
            }
            else {
                return galleryRecentPhotos?.count ?? 0
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionViewCuisines == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodItemSubCuisineCell", for: indexPath) as! HomeFoodItemSubCuisineCell
            cell.isDetailsScreen = true
            cell.labelName.text = arrayNames[indexPath.item]
            return cell
        }
        else if (collectionViewType == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCell", for: indexPath) as! HomeMenuCell
            cell.labelName.text = arrayNames[indexPath.item]
            return cell
        }
        else if (collectionViewRecentPhoto == collectionView) {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpLoadPhotoCell", for: indexPath) as! UpLoadPhotoCell
                return cell
            }
            else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
                cell.imageViewPhoto.image = arrayLocalGallery?[indexPath.item]
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
                cell.imageViewPhoto.setImage(urlString: galleryRecentPhotos?[indexPath.item] ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque2" : "placeHolderFoodItem2")
                return cell
            }
        }
        else if (collectionViewConnect == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialConnectCell", for: indexPath) as! SocialConnectCell
            cell.labelName.text = connectSocial?[indexPath.item]?.type ?? ""
            cell.imageViewIcon.setImage(
                urlString: connectSocial?[indexPath.item]?.type ?? "",
                placeHolderIcon: getSocialIcon(
                    titleName: connectSocial?[indexPath.item]?.type ?? "", urlString: ""
                ).0)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCollectionViewCell", for: indexPath) as! FoodItemCollectionViewCell
            
            return cell
        }
    }
    
    func getSocialIcon(titleName: String, urlString: String? = "") -> (String, String) {
        var placeHolder = ""
        var urlStringLocal = ""
        if titleName.lowercased() == "website" {
            placeHolder = "websiteGray"
            urlStringLocal = urlString ?? ""
        }
        else if titleName.lowercased() == "facebook" {
            placeHolder = "facebookGray"
            urlStringLocal = "https://www.facebook.com/\(urlString ?? "")"
        }
        else if titleName.lowercased() == "instagram" {
            placeHolder = "instagramGray"
            urlStringLocal = "https://www.instagram.com/\(urlString ?? "")"
        }
        else if titleName.lowercased() == "twitter" {
            placeHolder = "twitterGray"
            urlStringLocal = "http://twitter.com/\(urlString ?? "")"
        }
        else if titleName.lowercased() == "tiktok" {
            placeHolder = "https://www.tiktok.com/@\(urlString ?? "")"
//            placeHolder = "https://www.tiktok.com/tiktokGray\(urlString ?? "")"
        }
        else if titleName.lowercased() == "youtube" {
            placeHolder = "\(urlString ?? "")"
        }
        else if titleName.lowercased() == "email" {
            placeHolder = "emailGray"
        }
        return (placeHolder, urlStringLocal)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionViewRecentPhoto == collectionView) {
            if indexPath.section == 1 {
                print("Upload a photo cell click")
            }
            else {
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionViewRecentPhoto == collectionView) {
            if indexPath.section == 0 {
                ImagePickerManager().pickImage(self){ image in
                    //here is the image
                    if let token = self.modelGetBlobToken?.uri {
                        self.uploadImageToBlobStorage(token: token, image: image)
                    }
                }
            }
            else {
                navigateToAddAddressViewController()
            }
        }
        else if collectionView == collectionViewConnect {
            let connectSocial = connectSocial?[indexPath.item]
            if let socialType = connectSocial?.type {
                if socialType.lowercased() == "email" {
                    let mailComposeViewController = configuredMailComposeViewController(email: socialType)
                    if MFMailComposeViewController.canSendMail() {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                }
                else {
                    let socialData = getSocialIcon(titleName: socialType, urlString: connectSocial?.value)
                    
                    let urlString = socialData.1
                    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                    else {
                        showToast(message: "invalid social link please update in your profile")
                    }
                }
            }
        }
        else {
//            showToast(message: "there is no social link please update your profile")
        }
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.galleryRecentPhotos = galleryRecentPhotos
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//extension DeliveryDetailsViewController3: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    //Image Picker
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            if let imageData = image.jpegData(compressionQuality: 0.75) {
//                //                let fileData = imageData
//                if arrayLocalGallery == nil {
//                    arrayLocalGallery = [UIImage]()
//                }
////                arrayLocalGallery?.append(image)
//                uploadImage(image: image)
//            }
//            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//                //                let fileName = imageUrl.lastPathComponent
//            }
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}

extension DeliveryDetailsViewController3: MFMailComposeViewControllerDelegate {
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        controller.dismiss(animated: true, completion: nil)
    }
}



import Foundation

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose an avatar", message: nil, preferredStyle: .actionSheet)
    
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    var isProfileImage: Bool? = false
    
    override init(){
        super.init()
        
    }
    
    func setCameraConfiguration() {
        
        if let popoverController = alert.popoverPresentationController {
            // iPad-specific code
            alert = UIAlertController(title: isProfileImage! ? "Choose an avatar" : "Upload photo", message: nil, preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: isProfileImage! ? "Choose an avatar" : "Upload photo", message: nil, preferredStyle: .actionSheet)
           
        }
        
        let cameraAction = UIAlertAction(title: "Use camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Select from gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    func pickImage(isProfileImage: Bool? = false, _ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        self.isProfileImage = isProfileImage
        // Check if device is iPad
        
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        setCameraConfiguration()
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

extension DeliveryDetailsViewController3 {
    func getRestaurantDetail() {
        
        var parameters = [String: Any]()
        let parts: [HomeViewController.PlacePart] = [.amenities, .cuisines, .reviews, .timings, .webLinks, .photos]
        let featureRequestModel: HomeViewController.ModelFeaturedRequest = HomeViewController.ModelFeaturedRequest(
            ids: [modelRestuarantResponseData.id ?? ""],
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
            location: HomeViewController.Location(
                distanceUnit: .kilometers,
                latitude: userLocation?.coordinate.latitude ?? kUserCurrentLocation?.coordinate.latitude ?? 0.0,
                longitude: userLocation?.coordinate.longitude ?? kUserCurrentLocation?.coordinate.longitude ?? 0.0,
                radius: 32
            ),
            excludeRestaurantType: nil
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
    
    func getBlobToken() {
        APIs.getAPI(apiName: .getBlobTokenForRestaurant, parameters: nil, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelGetBlobToken? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBlobToken = model
        }
    }
    
    func uploadPhotoForRestaurant(imageUrl: String? = "") {
        let parameters = [
            "placeId": modelFeaturedResponse?.items?.first??.id ?? "",
            "photoWebUrls": [
                imageUrl
            ]
        ] as [String : Any]
        APIs.postAPI(apiName: isPrayerPlace ? .uploadPhotoForMosque : .uploadPhotoForRestaurant, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            if statusCode == 200 {
                self.getRestaurantDetail()
                self.navigateToSuccessPopUpViewController(imageUrl: imageUrl!, isShowPopUp: false)
            }
        }
    }
    
    func navigateToSuccessPopUpViewController(imageUrl: String, isShowPopUp: Bool? = true) {
        if isShowPopUp ?? true {
            let vc = UIStoryboard.init(name: StoryBoard.name.alertPopup.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ReviewSuccessPopUpViewController") as! ReviewSuccessPopUpViewController
            
            vc.arrayGalleryImages = [imageUrl]
            vc.didCloseTappedHandler = {
                
            }
            self.present(vc, animated: true)
        }
        else {
            galleryRecentPhotos?.append(imageUrl)
        }
    }
}

struct ModelGetBlobToken: Codable {
    let uri: String
}

///Blob Upload Storage
extension DeliveryDetailsViewController3 {
    func uploadImageToBlobStorage(token: String, image: UIImage) {
        //        let containerURL = "https://zabihahblob.blob.core.windows.net/profileimage"//containerName
        let currentDate1 = Date()
        let blobName = String(currentDate1.timeIntervalSinceReferenceDate)+".png"
        
        let tempToken = token.components(separatedBy: "?")
        
        let sasToken = tempToken.last ?? ""
        let containerURL = "\(tempToken.first ?? "")"
        print("containerURL with SAS: \(containerURL) ")
        
        let azureBlobStorage = AzureBlobStorage(containerURL: containerURL, sasToken: sasToken)
        azureBlobStorage.uploadImage(image: image, blobName: blobName) { success, error in
            if success {
                print("Image uploaded successfully!")
                if let imageURL = azureBlobStorage.getImageURL(containerURL: containerURL, blobName: blobName) {
                    print("Image URL: \(imageURL)")
                    DispatchQueue.main.async {
                        self.uploadPhotoForRestaurant(imageUrl: "\(imageURL)")
                    }
                } else {
                    print("Failed to construct image URL")
                }
            } else {
                print("Failed to upload image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        return()
    }
}
