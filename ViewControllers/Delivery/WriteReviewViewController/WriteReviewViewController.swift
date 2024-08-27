//
//  WriteReviewViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 21/08/2024.
//

import UIKit
import Cosmos

class WriteReviewViewController: UIViewController {
    @IBOutlet weak var labelTextViewCount: UILabel!
    @IBOutlet weak var viewButtonSubmitYourReviewBackGround: ViewButtonSetting!

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewStarCasmo: CosmosView!
    @IBOutlet weak var textViewReview: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonRadioYes: UIButton!
    @IBOutlet weak var buttonRadioNo: UIButton!
    @IBOutlet weak var imageViewYes: UIImageView!
    @IBOutlet weak var imageViewNo: UIImageView!
    @IBOutlet weak var buttonSubmitYourReview: UIButton!
    
    var textViewCount = 0 {
        didSet {
            if textViewReview.text == placeholderText {
                buttonSubmitYourReview.isEnabled = false
                viewButtonSubmitYourReviewBackGround?.backgroundColor = .clrDisableButton
                return
            }
            buttonSubmitYourReview.isEnabled = textViewCount > 0
            viewButtonSubmitYourReviewBackGround?.backgroundColor = textViewCount <= 0 ? .clrDisableButton : .clrLightBlue
        }
    }
    var modelGetRestaurantDetailResponse:  DeliveryDetailsViewController3.ModelGetRestaurantDetailResponse?
    var reviewDatum: ReviewsViewController.ReviewDatum!
    
    var isPrayerPlace: Bool = false
    
    var isFromEditReview: Bool = false
    let placeholderText = "Write..."
    var galleryRecentPhotos: [String]!
    var arrayDeletePhotos: [String]!
    var arrayLocalGallery: [UIImage]? {
        didSet {
            DispatchQueue.main.async {
                self.reviewButtonHandler()
                self.collectionView.reloadData()
            }
        }
    }
    var reviewPostedHandler: (() -> ())!
    
    var modelPostReview: ModelPostReview! {
        didSet {
            if modelPostReview.success ?? false {
                popViewController(animated: true)
                DispatchQueue.main.async {
                    self.reviewPostedHandler?()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        RecentPhotoCell.register(collectionView: collectionView)
        UpLoadPhotoCell.register(collectionView: collectionView)
        textViewReview.radius(radius: 12, color: .lightGray, borderWidth: 1)
        collectionView.reloadData()
        textViewReview.delegate = self
        getStarRating()
        textViewReview.text = placeholderText
        textViewReview.textColor = .lightGray
        if isFromEditReview {
            setData()
        }
        textViewCount = 0
    }
    func getStarRating() {
        viewStarCasmo.didTouchCosmos = { [self] rating in
            self.reviewButtonHandler()
        }
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonRadioYes(_ sender: Any) {
        imageViewYes.image = UIImage(named: "radioCheck")
        imageViewNo.image = UIImage(named: "radioUnCheck")
        buttonRadioYes.tag = 1
        reviewButtonHandler()
    }
    @IBAction func buttonRadioNo(_ sender: Any) {
        imageViewYes.image = UIImage(named: "radioUnCheck")
        imageViewNo.image = UIImage(named: "radioCheck")
        buttonRadioYes.tag = 0
        reviewButtonHandler()
    }
    @IBAction func buttonSubmitYourReview(_ sender: Any) {
        if textViewReview.text == "" {
            return
        }
        if isFromEditReview {
            editReview()
        }
        else {
            postReview()
        }
    }
    
    func setData() {
        textViewReview.textColor = .black
        viewStarCasmo.rating = reviewDatum.rating ?? 0
        textViewReview.text = reviewDatum.description
        if reviewDatum.returning ?? false {
            imageViewYes.image = UIImage(named: "radioCheck")
            imageViewNo.image = UIImage(named: "radioUnCheck")
            buttonRadioYes.tag = 1
        }
        else {
            imageViewYes.image = UIImage(named: "radioUnCheck")
            imageViewNo.image = UIImage(named: "radioCheck")
            buttonRadioYes.tag = 0
        }
        galleryRecentPhotos = reviewDatum.images
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.galleryRecentPhotos = galleryRecentPhotos
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func postReview() {
        let parameters = [
            "ItemId": modelGetRestaurantDetailResponse?.restuarantResponseData?.id ?? "",
            "Type": isPrayerPlace ? "prayer" : "rest",
            "Rating": viewStarCasmo.rating,
            "IsReturning": buttonRadioYes.tag == 1,
            "Description": textViewReview.text!
            //            "Images": isPrayerPlace ? "prayer" : "rest"
        ] as [String : Any]
        
        APIs.uploadImage(apiName: .postreview, imagesArray: arrayLocalGallery ?? [], imageParameter: "Images", parameter: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelPostReview? = APIs.decodeDataToObject(data: responseData)
            DispatchQueue.main.async {
                self.modelPostReview = model
            }
        }
    }
    
    func editReview() {
        let parameters = [
            "id": reviewDatum.id ?? "",
            "ItemId": reviewDatum.itemId ?? "",
            "DeleteImages": arrayDeletePhotos ?? [],
            "Type": isPrayerPlace ? "prayer" : "rest",
            "Rating": viewStarCasmo.rating,
            "IsReturning": buttonRadioYes.tag == 1,
            "Description": textViewReview.text!
            //            "newImages": arrayLocalGallery,
        ] as [String : Any]
        
        APIs.uploadImage(apiName: .editreview, imagesArray: arrayLocalGallery ?? [], imageParameter: "newImages", parameter: parameters, requestType: "PUT", viewController: self) { responseData, success, errorMsg in
            if let model: ModelPostReview? = APIs.decodeDataToObject(data: responseData) {
                DispatchQueue.main.async {
                    self.modelPostReview = model
                }
            }
        }
    }
    
    func removeImageHandler(indexPath: IndexPath) {
        if indexPath.section == 1 {
            //New Photos
            arrayLocalGallery?.remove(at: indexPath.item)
        }
        else if indexPath.section == 2 {
            //Old Photos
            if arrayDeletePhotos == nil {
                arrayDeletePhotos = [String]()
            }
            arrayDeletePhotos.append(galleryRecentPhotos[indexPath.item])
            galleryRecentPhotos.remove(at: indexPath.item)
        }
        self.reviewButtonHandler()
        collectionView.reloadData()
    }
    
    func reviewButtonHandler() {
        let completeText = "\((textViewReview.text ?? ""))"
        self.labelTextViewCount.text = "\(completeText.count)/500"
        self.textViewCount = textViewReview.text.count
    }
}


extension WriteReviewViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.reviewButtonHandler()
        }
        return self.textLimit(existingText: textView.text,
                              newText: text,
                              limit: 500)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}

extension WriteReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12 )
    //    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3.4
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return arrayLocalGallery?.count ?? 0
        }
        else {
            return galleryRecentPhotos?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpLoadPhotoCell", for: indexPath) as! UpLoadPhotoCell
            cell.stackViewBackGround.radius(radius: 12, color: .lightGray, borderWidth: 1)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
            cell.imageViewPhoto.image = arrayLocalGallery?[indexPath.item]
            cell.stackViewBackGround.radius(radius: 12, color: .lightGray, borderWidth: 1)
            cell.isCancelButtonShow = true
            cell.removeImageHandler = removeImageHandler
            cell.indexPath = indexPath
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
            cell.stackViewBackGround.radius(radius: 12, color: .lightGray, borderWidth: 1)
            cell.imageViewPhoto.setImage(urlString: galleryRecentPhotos?[indexPath.item] ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque" : "placeholderRestaurantSubIcon")
            cell.isCancelButtonShow = isFromEditReview
            cell.removeImageHandler = removeImageHandler
            cell.indexPath = indexPath
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //            DispatchQueue.main.async {
        //                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        //            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
//            openGallary()
            ImagePickerManager().pickImage(self){ image in
                    //here is the image
                if self.arrayLocalGallery == nil {
                    self.arrayLocalGallery = [UIImage]()
                }
                self.arrayLocalGallery?.append(image)
            }
        }
        else {
            navigateToAddAddressViewController()
        }
    }
}

//extension WriteReviewViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    
//    //Image Picker
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            if let imageData = image.jpegData(compressionQuality: 0.75) {
//                //                let fileData = imageData
//                if arrayLocalGallery == nil {
//                    arrayLocalGallery = [UIImage]()
//                }
//                arrayLocalGallery?.append(image)
//                //                uploadImage(image: image)
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
//    
//    func openGallary() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.allowsEditing = false //If you want edit option set "true"
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        self.present(imagePickerController, animated: true, completion: nil)
//    }
//}

extension WriteReviewViewController {
    // MARK: - ModelPostReview
    struct ModelPostReview: Codable {
        let recordFound, success: Bool?
        let message, innerExceptionMessage: String?
        let token: String?
        let totalCounts, totalPages: Int?
        let images: [String]?
        //        let reviewDataObj: JSONNull?
    }
}
