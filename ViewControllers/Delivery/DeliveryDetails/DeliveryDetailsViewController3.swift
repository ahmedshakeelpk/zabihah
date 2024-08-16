//
//  DeliveryDetailsViewController3.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 28/07/2024.
//

import UIKit
import CoreLocation

protocol DeliveryDetailsViewController3Delegate: AnyObject {
    func changeFavouriteStatusFromDetails(isFavourite: Bool, indexPath: IndexPath)
}

class DeliveryDetailsViewController3: UIViewController {
    @IBOutlet weak var viewAddressDevider: UIView!
    @IBOutlet weak var imageViewRestaurantIcon: UIImageView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelDistanceAway: UILabel!
    @IBOutlet weak var collectionViewRecentPhoto: UICollectionView!
    @IBOutlet weak var collectionViewConnect: UICollectionView!
    @IBOutlet weak var buttonBack: UIView!
    @IBOutlet weak var collectionViewCountry: UICollectionView!
    @IBOutlet weak var collectionViewType: UICollectionView!
    @IBOutlet weak var collectionViewFoodItem: UICollectionView!
    
    @IBOutlet weak var labelRestaurantDetails: UILabel!
    @IBOutlet weak var buttonAmenities: UIButton!
    @IBOutlet weak var buttonHalalSummary: UIButton!
    @IBOutlet weak var labelHalalSummaryDetails: UILabel!
    @IBOutlet weak var viewShareBackGround: UIView!
    @IBOutlet weak var viewCallBackGround: UIView!
    
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

    
    var delegate: DeliveryDetailsViewController3Delegate!
    var arrayLocalGallery: [UIImage]? {
        didSet {
            collectionViewRecentPhoto.reloadData()
        }
    }
    var isPrayerPlace: Bool = false
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces", "Pickup & delivery", "Prayer spaces"]
    var userLocation: CLLocation!
    var halalRestuarantResponseData: HomeViewController.ModelRestuarantResponseData!
    var selectedMenuCell: Int!
    var indexPath: IndexPath!
    
    var modelGetRestaurantDetailResponse: ModelGetRestaurantDetailResponse? {
        didSet {
            print(modelGetRestaurantDetailResponse as Any)
            setData()
        }
    }
    var galleryRecentPhotos: [String]? {
        didSet {
            collectionViewRecentPhoto.reloadData()
        }
    }
    var connectSocial: [Social]? {
        didSet {
            collectionViewConnect.reloadData()
        }
    }
    var timingOpenClose: [Timing]? {
        didSet {
            
        }
    }
    var amenitiesData: [Amenities]? {
        didSet {
            
        }
    }
    
    var modelPostFavouriteDeleteResponse: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? {
        didSet {
            print(modelPostFavouriteDeleteResponse as Any)
            if modelPostFavouriteDeleteResponse?.success ?? false {
                if let isFavourite = self.modelGetRestaurantDetailResponse?.restuarantResponseData?.isFavorites {
                    delegate.changeFavouriteStatusFromDetails(isFavourite: !isFavourite, indexPath: indexPath)
                    modelGetRestaurantDetailResponse?.restuarantResponseData?.isFavorites = !isFavourite
                }
            }
            else {
                self.showAlertCustomPopup(title: "Error!", message: modelPostFavouriteDeleteResponse?.message ?? "", iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setConfiguration()
        getFeaturedRestaurants()
    }
    @IBAction func buttonFavourite(_ sender: Any) {
        postFavouriteRestaurants()
    }
    @IBAction func buttonCall(_ sender: Any) {
        dialNumber(number: modelGetRestaurantDetailResponse?.restuarantResponseData?.phone ?? "")
    }
    
    @IBAction func buttonShare(_ sender: Any) {
        let text = modelGetRestaurantDetailResponse?.restuarantResponseData?.shareLink ?? ""
            let textShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func buttonAmenities(_ sender: Any) {
        
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
    }
    @IBAction func buttonHalalSummary(_ sender: Any) {
        buttonHalalSummary.tag = buttonHalalSummary.tag == 0 ? 1 : 0
        viewHalalSummaryDetailsBackGround.isHidden = buttonHalalSummary.tag == 0
        self.imageViewHalalSummaryDropDown.image = UIImage(named: buttonHalalSummary.tag == 0 ? "arrowDropDown" : "forwardArrowGray")
    }
    
    func setConfiguration() {
        viewAddressDevider.circle()
        imageViewRestaurantIcon.circle()
        HomeFoodItemSubSuisineCell.register(collectionView: collectionViewCountry)
        RecentPhotoCell.register(collectionView: collectionViewRecentPhoto)
        UpLoadPhotoCell.register(collectionView: collectionViewRecentPhoto)
        SocialConnectCell.register(collectionView: collectionViewConnect)

        collectionViewCountry.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        collectionViewRecentPhoto.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        collectionViewConnect.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
    }
    func setData() {
        if let restuarantResponseData = modelGetRestaurantDetailResponse?.restuarantResponseData {
            
            labelRestaurantName.text = restuarantResponseData.name ?? ""
            labelAddress.text = restuarantResponseData.address ?? ""
            labelDistanceAway.text = "\(restuarantResponseData.distance ?? 0)\(restuarantResponseData.distanceUnit ?? "")"
            imageViewRestaurantIcon.setImage(urlString: restuarantResponseData.iconImage ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque" : "placeholderRestaurantSubIcon")
            
            labelRestaurantDetails.text = restuarantResponseData.description
            labelHalalSummaryDetails.text = restuarantResponseData.halalDescription
            
            labelFullHalalMenu.text = restuarantResponseData.isFullHalal ?? false ? "Full halal menu" : "NO"
            labelAlcohol.text = restuarantResponseData.isalcohhol ?? false ? "YES" : "NO alcohol"
            if modelGetRestaurantDetailResponse?.timing?.count ?? 0 > 0 {
                labelCloseOpen.text = "Closes at \(modelGetRestaurantDetailResponse?.timing?.last?.closeTime ?? "")"
            }
            imageViewFavourite.image = UIImage(named: restuarantResponseData.isFavorites ?? false ? "heartFavourite" : "heartMehroon")
            labelReviews.text = "\(restuarantResponseData.reviews ?? 0) reviews"
            labelReturning.text = "\(restuarantResponseData.returning ?? 0) returning"
            labelRating.text = "Rating: \(restuarantResponseData.rating ?? 0)"
            viewShareBackGround.isHidden = modelGetRestaurantDetailResponse?.restuarantResponseData?.shareLink ?? "" == ""
            viewCallBackGround.isHidden = modelGetRestaurantDetailResponse?.restuarantResponseData?.phone ?? "" == ""
            
            if let timing = modelGetRestaurantDetailResponse?.timing, timing.count > 0 {
                timingOpenClose = timing
            }
            if let amenities = modelGetRestaurantDetailResponse?.amenities, amenities.count > 0 {
                amenitiesData = amenities
            }
            if let gallery = restuarantResponseData.gallery, gallery.count > 0 {
                galleryRecentPhotos = gallery
            }
            else {
                collectionViewRecentPhoto.reloadData()
            }
            if let connect = modelGetRestaurantDetailResponse?.social, connect.count > 0 {
                connectSocial = connect
            }
        }
    }
    
    
    func getFeaturedRestaurants() {
        let parameters = [
            "lat": userLocation?.coordinate.latitude as Any,
            "long": userLocation?.coordinate.longitude as Any,
            "id": halalRestuarantResponseData.id ?? "",
            "type": isPrayerPlace ? "prayer" : "rest"
        ]
        APIs.postAPI(apiName: .getrestaurantdetail, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetRestaurantDetailResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetRestaurantDetailResponse = model
        }
    }
    
    func openGallary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func postFavouriteRestaurants() {
        let parameters = [
            "Id": modelGetRestaurantDetailResponse?.restuarantResponseData?.id ?? "",
            "isMark": !(modelGetRestaurantDetailResponse?.restuarantResponseData?.isFavorites ?? false),
            "type" : isPrayerPlace ? "prayer" : "rest"
        ] as [String : Any]
       
        APIs.postAPI(apiName: .postfavouriterestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelPostFavouriteDeleteResponse = model
        }
    }
}


extension DeliveryDetailsViewController3: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: collectionViewFoodItem == collectionView ? 0 : 8, bottom: 0, right: collectionViewFoodItem == collectionView ? 0 : 12 )
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (collectionViewCountry == collectionView) {
            let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 22
            return CGSize(width: width, height: (collectionViewCountry == collectionView) ? 22 : 28)
        }
        else if (collectionViewType == collectionView) {
            let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 22
            return CGSize(width: width, height: (collectionViewCountry == collectionView) ? 22 : 28)
        }
        else if (collectionViewRecentPhoto == collectionView) {
            let width = collectionView.frame.width / 3.4
            return CGSize(width: 90, height: 90)
        }
        else if (collectionViewConnect == collectionView) {
            let width = collectionView.frame.width / 3.4
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
        case collectionViewCountry:
            return 0
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
        if (collectionViewCountry == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodItemSubSuisineCell", for: indexPath) as! HomeFoodItemSubSuisineCell
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
                cell.imageViewPhoto.setImage(urlString: galleryRecentPhotos?[indexPath.item] ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque" : "placeholderRestaurantSubIcon")
                return cell
            }
        }
        else if (collectionViewConnect == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialConnectCell", for: indexPath) as! SocialConnectCell
            cell.labelName.text = connectSocial?[indexPath.item].title ?? ""
            
            cell.imageViewIcon.setImage(urlString: connectSocial?[indexPath.item].url ?? "", placeHolderIcon: getSocialIcon(titleName: connectSocial?[indexPath.item].title ?? ""))
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCollectionViewCell", for: indexPath) as! FoodItemCollectionViewCell

            return cell
        }
    }
    
    func getSocialIcon(titleName: String) -> String {
        var placeHolder = ""
        if titleName.lowercased() == "website" {
            placeHolder = "websiteGray"
        }
        else if titleName.lowercased() == "facebook" {
            placeHolder = "facebookGray"
        }
        else if titleName.lowercased() == "instagram" {
            placeHolder = "instagramGray"
        }
        else if titleName.lowercased() == "twitter" {
            placeHolder = "tiktokGray"
        }
        else if titleName.lowercased() == "tiktok" {
            placeHolder = "tiktokGray"
        }
        else if titleName.lowercased() == "email" {
            placeHolder = "emailGray"
        }
        return placeHolder
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
                openGallary()
            }
            else {
                
            }
        }
        else if collectionView == collectionViewConnect {
            if let socialUrl = connectSocial?[indexPath.item].url {
                if let url = URL(string: socialUrl), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                else {
                    showToast(message: "invalid social link please update in your profile")
                }
            }
            else {
                showToast(message: "there is no social link please update your profile")
            }
        }
    }
}

extension DeliveryDetailsViewController3: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.75) {
                //                let fileData = imageData
                if arrayLocalGallery == nil {
                    arrayLocalGallery = [UIImage]()
                }
                arrayLocalGallery?.append(image)
            }
            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                //                let fileName = imageUrl.lastPathComponent
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
