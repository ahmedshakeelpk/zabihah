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
    
    @IBOutlet weak var viewTagBackGround: UIView!
    @IBOutlet weak var viewHalalSummaryBackGround: UIView!
    @IBOutlet weak var viewHalalMenuBackGround: UIView!
    @IBOutlet weak var viewAmenitiesBackGround: UIView!
    @IBOutlet weak var stackViewConnectBackGround: UIStackView!
    @IBOutlet weak var viewFavouriteBackGround: UIView!
    
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
    @IBOutlet weak var buttonRating: UIButton!
    
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
    
    
    var modelAddImageUrlsToPhoto: ModelAddImageUrlsToPhoto? {
        didSet {
            if modelAddImageUrlsToPhoto?.success ?? false {
                if galleryRecentPhotos == nil {
                    galleryRecentPhotos = [String]()
                }
                galleryRecentPhotos?.append(modelAddImageUrlsToPhoto?.imageUrls?.first ?? "")
                galleryRecentPhotos = galleryRecentPhotos?.reversed()
            }
        }
    }
    
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
    
    var modelGetRestaurantDetailResponse: ModelGetRestaurantDetailResponse? {
        didSet {
            print(modelGetRestaurantDetailResponse as Any)
            setData()
        }
    }
    var galleryRecentPhotos: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewRecentPhoto.reloadData()
            }
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
        isPrayerPlace = modelRestuarantResponseData.type ?? "" != "rest"
        setConfiguration()
        getRestaurantDetail()
        enableSwipeToPop()
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
        self.imageViewHalalSummaryDropDown.image = UIImage(named: buttonHalalSummary.tag == 0 ? "arrowDropDown" : "forwardArrowGray")
    }
    
    func setConfiguration() {
        viewAddressDevider.circle()
        imageViewRestaurantIcon.circle()
        HomeFoodItemSubSuisineCell.register(collectionView: collectionViewCountry)
        RecentPhotoCell.register(collectionView: collectionViewRecentPhoto)
        UpLoadPhotoCell.register(collectionView: collectionViewRecentPhoto)
        SocialConnectCell.register(collectionView: collectionViewConnect)
        
//        viewFavouriteBackGround.isHidden = isFeaturedCell
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
            viewHalalSummaryBackGround.isHidden = restuarantResponseData.halalDescription ?? "" == ""
            viewHalalMenuBackGround.isHidden = isPrayerPlace
            
            labelFullHalalMenu.text = restuarantResponseData.isFullHalal ?? false ? "Full halal menu" : "NO"
            labelAlcohol.text = restuarantResponseData.isalcohhol ?? false ? "YES" : "No alcohol"
            if modelGetRestaurantDetailResponse?.timing?.count ?? 0 > 0 {
                labelCloseOpen.text = "Closes at \(is12HourFormat ? "\(modelGetRestaurantDetailResponse?.timing?.last?.closeTime ?? "")".time12String : "\(modelGetRestaurantDetailResponse?.timing?.last?.closeTime ?? "")".time24String)"
            }
            imageViewFavourite.image = UIImage(named: restuarantResponseData.isFavorites ?? false ? "heartFavourite" : "heartMehroon")
            labelReviews.text = "\(restuarantResponseData.reviews ?? 0) reviews"
            labelReturning.text = "\(restuarantResponseData.returning ?? 0) returning"
            labelRating.text = "Rating: \(restuarantResponseData.rating ?? 0)"
            viewShareBackGround.isHidden = modelGetRestaurantDetailResponse?.restuarantResponseData?.shareLink ?? "" == ""
            viewCallBackGround.isHidden = modelGetRestaurantDetailResponse?.restuarantResponseData?.phone ?? "" == ""
            viewTagBackGround.isHidden = restuarantResponseData.tags == nil || restuarantResponseData.tags == ""
            if var tags = restuarantResponseData.tags?.split(separator: ",").map({ String($0)}) {
                if tags.last == "" || tags.last == " "{
                    tags.removeLast()
                }
                arrayNames = tags
                collectionViewCountry.reloadData()
            }
            
            if let timing = modelGetRestaurantDetailResponse?.timing, timing.count > 0 {
                timingOpenClose = timing
            }
            if let amenities = modelGetRestaurantDetailResponse?.amenities, amenities.count > 0 {
                amenitiesData = amenities
                viewAmenitiesBackGround.isHidden = false
            }
            else {
                viewAmenitiesBackGround.isHidden = true
            }
            if let gallery = restuarantResponseData.gallery, gallery.count > 0 {
                galleryRecentPhotos = gallery.reversed()
            }
            else {
                collectionViewRecentPhoto.reloadData()
            }
            if let connect = modelGetRestaurantDetailResponse?.social, connect.count > 0 {
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
//        vc.galleryRecentPhotos = self.galleryRecentPhotos
        vc.modelGetRestaurantDetailResponse = modelGetRestaurantDetailResponse
        vc.isPrayerPlace = isPrayerPlace
        vc.reviewPostedHandler = {
            self.getRestaurantDetail()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getRestaurantDetail() {
        let parameters = [
            "lat": userLocation?.coordinate.latitude ?? 0,
            "long": userLocation?.coordinate.longitude ?? 0,
            "id": modelRestuarantResponseData.id ?? "",
            "type": modelRestuarantResponseData.type ?? ""
        ] as [String : Any]
        APIs.postAPI(apiName: .getrestaurantdetail, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetRestaurantDetailResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetRestaurantDetailResponse = model
        }
    }
    
//    func openGallary() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.allowsEditing = false //If you want edit option set "true"
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        self.present(imagePickerController, animated: true, completion: nil)
//    }
    
    func postFavouriteRestaurants() {
        let parameters = [
            "Id": modelGetRestaurantDetailResponse?.restuarantResponseData?.id ?? "",
            "isMark": !(modelGetRestaurantDetailResponse?.restuarantResponseData?.isFavorites ?? false),
            "type" : modelRestuarantResponseData.type ?? ""
        ] as [String : Any]
        
        APIs.postAPI(apiName: .postfavouriterestaurants, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: FindHalalFoodCell.ModelPostFavouriteDeleteResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelPostFavouriteDeleteResponse = model
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
            return arrayNames.count ?? 0
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
            cell.imageViewIcon.setImage(urlString: connectSocial?[indexPath.item].url ?? "", placeHolderIcon: getSocialIcon(titleName: connectSocial?[indexPath.item].title ?? "", urlString: "").0)
            
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
            placeHolder = "https://www.tiktok.com/tiktokGray\(urlString ?? "")"
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
//                openGallary()
                ImagePickerManager().pickImage(self){ image in
                        //here is the image
                    self.uploadImage(image: image)
                }
            }
            else {
                navigateToAddAddressViewController()
            }
        }
        else if collectionView == collectionViewConnect {
            if let socialUrl = connectSocial?[indexPath.item].url {
                if (connectSocial?[indexPath.item].title ?? "").lowercased() == "email" {
                    let mailComposeViewController = configuredMailComposeViewController(email: connectSocial?[indexPath.item].url ?? "")
                    if MFMailComposeViewController.canSendMail() {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                }
                else {
                    let socialData = getSocialIcon(titleName: connectSocial?[indexPath.item].title ?? "", urlString: socialUrl)
                    
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
                showToast(message: "there is no social link please update your profile")
            }
        }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.galleryRecentPhotos = galleryRecentPhotos
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func uploadImage(image: UIImage) {
        let parameter = ["Id": modelRestuarantResponseData.id ?? "",
                         "type": isPrayerPlace ? "prayer" : "rest"] as [String : Any]
        APIs.uploadImage(apiName: .AddImageUrlsToPhoto, imagesArray: [image], imageParameter: "UploadImage", parameter: parameter) { responseData, success, errorMsg in
            let model: ModelAddImageUrlsToPhoto? = APIs.decodeDataToObject(data: responseData)
            self.modelAddImageUrlsToPhoto = model
        }
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
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
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

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        alert.popoverPresentationController?.sourceView = self.viewController!.view

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
