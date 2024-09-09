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
    
    var arrayAllUpLoadedPhotos = [String]()
    
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
    var modelGetRestaurantDetailResponse:  HomeViewController.ModelRestuarantResponseData?
    var reviewDatum: HomeViewController.Review!
    
    var isPrayerPlace: Bool = false
    
    var isFromEditReview: Bool = false
    let placeholderText = "Write..."
    var galleryRecentPhotos: [String?]?
    var arrayDeletePhotos: [String?]?
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
            if modelPostReview.id != "" {
                popViewController(animated: true)
                DispatchQueue.main.async {
                    self.reviewPostedHandler?()
                }
            }
        }
    }
    
    var modelGetBlobToken: ModelGetBlobToken? {
        didSet{
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewReview.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        
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
        getBlobToken()
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
        if arrayLocalGallery?.count ?? 0 > 0{
            if let token = self.modelGetBlobToken?.uri {
                for image in arrayLocalGallery ?? [] {
                    self.uploadImageToBlobStorage(token: token, image: image)
                }
            }
            else {
                getBlobToken()
            }
        } 
        else {
            if isFromEditReview {
                editReview()
            }
            else {
                postReview()
            }
        }
        
//        if isFromEditReview {
//            editReview()
//        }
//        else {
//            if arrayLocalGallery?.count ?? 0 > 0{
//                if let token = self.modelGetBlobToken?.uri {
//                    for image in arrayLocalGallery ?? [] {
//                        self.uploadImageToBlobStorage(token: token, image: image)
//                    }
//                }
//                else {
//                    getBlobToken()
//                }
//            }
//            else {
//                postReview()
//            }
//        }
    }
    
    func setData() {
        textViewReview.textColor = .black
        viewStarCasmo.rating = Double(reviewDatum.rating ?? 0)
        textViewReview.text = reviewDatum.comment
        if reviewDatum.willReturn ?? false {
            imageViewYes.image = UIImage(named: "radioCheck")
            imageViewNo.image = UIImage(named: "radioUnCheck")
            buttonRadioYes.tag = 1
        }
        else {
            imageViewYes.image = UIImage(named: "radioUnCheck")
            imageViewNo.image = UIImage(named: "radioCheck")
            buttonRadioYes.tag = 0
        }
        galleryRecentPhotos = reviewDatum.photoWebUrls
    }
    
    func navigateToAddAddressViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.galleryStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.galleryRecentPhotos = galleryRecentPhotos
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func postReview() {
        let parameters = [
            "placeId": modelGetRestaurantDetailResponse?.id ?? "",
            "rating": viewStarCasmo.rating,
            "comment": textViewReview.text!,
            "willReturn": buttonRadioYes.tag == 1,
            "photoWebUrls": arrayAllUpLoadedPhotos
        ] as [String : Any]
        
        APIs.postAPI(apiName: .postReview, parameters: parameters, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelPostReview? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostReview = model  
            }
        }
    }
    
    func editReview() {
//        let parameters = [
//            "id": reviewDatum.id ?? "",
//            "ItemId": reviewDatum.itemId ?? "",
//            "DeleteImages": arrayDeletePhotos ?? [],
//            "Rating": viewStarCasmo.rating,
//            "IsReturning": buttonRadioYes.tag == 1,
//            "Description": textViewReview.text!
//            //            "newImages": arrayLocalGallery,
//        ] as [String : Any]
        
        let parameters = [
            "id":  reviewDatum.id ?? "",
            "placeId": reviewDatum.place?.id ?? "",
            "rating": viewStarCasmo.rating,
            "comment": textViewReview.text!,
            "willReturn": buttonRadioYes.tag == 1,
            "photoWebUrls": arrayAllUpLoadedPhotos
        ] as [String : Any]
        
        
        APIs.postAPI(apiName: .postReview, parameters: parameters, methodType: .put, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelPostReview? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelPostReview = ModelPostReview(rating: nil, id: "test id", createdOn: nil, updatedOn: nil, willReturn: nil, type: nil, comment: nil, isDeleted: nil, photoWebUrls: nil, createdBy: nil, updatedBy: nil, place: nil)
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
            arrayDeletePhotos?.append(galleryRecentPhotos?[indexPath.item] ?? "")
            galleryRecentPhotos?.remove(at: indexPath.item)
        }
        self.reviewButtonHandler()
        collectionView.reloadData()
    }
    
    func reviewButtonHandler() {
        let completeText = "\((textViewReview.text ?? ""))"
        self.labelTextViewCount.text = "\(completeText.count)/500"
        self.textViewCount = textViewReview.text.count
    }
    
    func getBlobToken() {
        APIs.getAPI(apiName: isPrayerPlace ? .getBlobTokenForMosque : .getBlobTokenForReview, parameters: nil, methodType: .get, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelGetBlobToken? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBlobToken = model
        }
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
        let rating: Int?
        let id: String?
        let createdOn, updatedOn: String?
        let willReturn: Bool?
        let type, comment: String?
        let isDeleted: Bool?
        let photoWebUrls: [String]?
        let createdBy, updatedBy: String?
        let place: Place?
    }

    // MARK: - Place
    struct Place: Codable {
        let id: String?
        let iconImageWebUrl: String?
        let name, address: String?
    }
}

///Blob Upload Storage
extension WriteReviewViewController {
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
                        self.arrayAllUpLoadedPhotos.append("\(imageURL)")
                        self.allPhotosUploaded()
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
    
    func allPhotosUploaded() {
        if self.arrayAllUpLoadedPhotos.count == self.arrayLocalGallery?.count {
            if galleryRecentPhotos == nil {
                galleryRecentPhotos = [String]()
            }
            galleryRecentPhotos?.append(contentsOf: arrayAllUpLoadedPhotos)
            arrayAllUpLoadedPhotos = galleryRecentPhotos?.compactMap { $0 } ?? []
            if isFromEditReview {
                self.editReview()
            }
            else {
                self.postReview()
            }
        }
    }
}
