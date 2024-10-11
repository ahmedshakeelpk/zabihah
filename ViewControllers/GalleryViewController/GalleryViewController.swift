//
//  GalleryViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/08/2024.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelRestaurant: UILabel!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewRestarurantDetailBackGround: UIView!
    @IBOutlet weak var viewUserDetailBackGround: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewLeftArrowBackGround: UIView!
    @IBOutlet weak var viewRightArrowBackGround: UIView!
    @IBOutlet weak var buttonRight: UIButton!
    
    @IBOutlet weak var viewCountBackGround: UIView!
    @IBOutlet weak var labelImageCount: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var viewButtonDeleteBackGround: UIView!
    
    var modelFeaturedResponse: HomeViewController.ModelFeaturedResponse? = nil
    var isFromDetailsViewController: Bool = false
    var modelPhotos: [HomeViewController.Photos?]? = nil
    var galleryRecentPhotos: [String?]?
    var totalImages = 10
    var deletePhotoHandler: (() -> ())!
    var currentPage:Int = 0
    var isPrayerPlace: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
    }
    
    func setConfiguration() {
        GalleryViewControllerCell.register(collectionView: collectionView)
        if isFromDetailsViewController {
            imageViewRestaurant.circle()
            if let restuarantResponseData = modelFeaturedResponse?.items?[0] {
                imageViewRestaurant.setImage(urlString: restuarantResponseData.iconImageWebUrl ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque2" : "placeHolderFoodItem2")
                
                labelRestaurant.text = restuarantResponseData.name ?? ""
                labelAddress.text = "\(restuarantResponseData.address ?? ""), \(restuarantResponseData.secondaryAddress ?? "")\n\(restuarantResponseData.city ?? ""), \(restuarantResponseData.state ?? "") \(restuarantResponseData.zip ?? "")"
                
                if let photos = restuarantResponseData.photos, photos.count > 0 {
//                    let sortedGalleryPhotos = photos
//                        .compactMap { $0 }  // Remove any nil values
//                        .sorted { (photo1, photo2) -> Bool in
//                            // Sorting based on createdDate (if available)
//                            // Ensure to safely unwrap createdDate and sort in descending order
//                            if let date1 = photo1.createdDate, let date2 = photo2.createdDate {
//                                return date1 > date2  // Sort by date in descending order
//                            }
//                            return false  // Return false if dates are nil
//                        }
//                    self.modelFeaturedResponse?.items?[0]?.photos = sortedGalleryPhotos
                    modelPhotos = photos
                    galleryRecentPhotos = photos.compactMap { $0?.photoWebUrl }
                }
            }
            setDeleteButton(index:0)
        }
        else {
            self.viewRestarurantDetailBackGround.isHidden = true
            self.viewUserDetailBackGround.isHidden = true
        }
        
        totalImages = galleryRecentPhotos?.count ?? 0
        // Do any additional setup after loading the view.
        
        labelImageCount.text = "\(1)/\(totalImages)"
        viewCountBackGround.circle()
        viewLeftArrowBackGround.circle()
        viewRightArrowBackGround.circle()
        viewLeftArrowBackGround.isHidden = true
        if totalImages == 1 {
            viewLeftArrowBackGround.isHidden = true
            viewRightArrowBackGround.isHidden = true
        }
        collectionView.reloadData()
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonLeft(_ sender: Any) {
        leftArrowTapped()
    }
    @IBAction func buttonDelete(_ sender: Any) {
        navigateToProfileDeleteViewController()
    }
    
    func setDeleteButton(index: Int) {
        let photo = modelPhotos?[index]
        let photoUserId = photo?.user?.id ?? ""
        let userId = kModelGetUserProfileResponse?.id ?? ""
        
        self.viewButtonDeleteBackGround.isHidden = !(photoUserId == userId)
        labelUserName.text = "\(photo?.user?.firstName ?? "") \(photo?.user?.lastName ?? "")"
        labelDate.text = convertDate(dateString: photo?.createdDate ?? "")
    }
    
    func leftArrowTapped() {
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < galleryRecentPhotos?.count ?? 0 && nextItem.row >= 0{
            self.collectionView.scrollToItem(at: nextItem, at: .right, animated: true)
        }
    }
    @IBAction func buttonRight(_ sender: Any) {
        rightArrowTapped()
    }
    
    func rightArrowTapped() {
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < galleryRecentPhotos?.count ?? 0 {
            self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }
    }
    
    func convertDate(dateString: String) -> String {
        // 1. Create a date formatter for the input date string format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Date format for the input
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // 2. Convert the string to a Date object
        if let date = inputFormatter.date(from: dateString) {
            
            // 3. Create another date formatter for the desired output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy" // Desired format
            outputFormatter.timeZone = TimeZone.current
            
            // 4. Convert the Date to the desired string format
            let formattedDate = outputFormatter.string(from: date)
            print(formattedDate) // Output: September 16, 2024
            return formattedDate
        }
        return ""
    }
    
    
    func navigateToProfileDeleteViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileDeleteViewController") as! ProfileDeleteViewController
        vc.stringTitle = ""
//        vc.stringTitle = "User Address"
        vc.stringSubTitle = "Are you sure, you want to delete photo?         "
        vc.stringDescription = ""
        vc.stringButtonDelete = "Yes, delete"
        vc.stringButtonCancel = "Cancel"
        vc.buttonDeleteHandler = {
            print("delete button press")
            self.photoDelete()
        }
        self.present(vc, animated: true)
    }
    func photoDelete() {
        let photo = modelPhotos?[currentPage]
        let photoUserId = photo?.id ?? ""
        let parameters = [
            "photoId": photoUserId
        ]
        APIs.getAPI(apiName: .photoDelete, parameters: parameters, isPathParameters: true, methodType: .delete, viewController: self) { responseData, success, errorMsg, statusCode in
            let model: ModelPostFavouriteRestaurantsResponse? = APIs.decodeDataToObject(data: responseData)
            if statusCode == 200 {
                self.modelFeaturedResponse?.items?[0]?.photos?.remove(at: self.currentPage)
                self.galleryRecentPhotos?.remove(at: self.currentPage)
                self.modelPostFavouriteRestaurantsResponse = model
                DispatchQueue.main.async {
                    self.deletePhotoHandler?()
//                    self.setConfiguration()
                    
                    self.totalImages = self.galleryRecentPhotos?.count ?? 0
                    // Do any additional setup after loading the view.
                    self.labelImageCount.text = "\(self.currentPage)/\(self.totalImages)"
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var modelPostFavouriteRestaurantsResponse: ModelPostFavouriteRestaurantsResponse? {
        didSet {
//            if let isFavourite = self.modelFeaturedResponse?.items?.first??.isMyFavorite {
//                
//                DispatchQueue.main.async {
//                    self.modelFeaturedResponse?.items?[0]?.isMyFavorite = !isFavourite
////                    self.delegate?.changeFavouriteStatusFromDetails(isFavourite: !isFavourite, indexPath: self.indexPath)
//                }
//                modelFeaturedResponse?.items?[0]?.isMyFavorite = !isFavourite
//            }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12 )
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryRecentPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryViewControllerCell", for: indexPath) as! GalleryViewControllerCell
        cell.imageViewGalleryImage.setImage(urlString: galleryRecentPhotos?[indexPath.row] ?? "", placeHolderIcon: "placeHolderFoodItem")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //            DispatchQueue.main.async {
        //                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        //            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        selectedCell = indexPath.item
        
    }
    
    func scrollViewDidScroll(_ scrollView:UIScrollView) {
        let midX:CGFloat = scrollView.bounds.midX
        let midY:CGFloat = scrollView.bounds.midY
        let point:CGPoint = CGPoint(x:midX, y:midY)
        
        guard let indexPath:IndexPath = collectionView.indexPathForItem(at:point)
        else {
            return
        }
        
        currentPage = indexPath.item
        labelImageCount.text = "\(currentPage+1)/\(totalImages)"
        setDeleteButton(index:currentPage)
        viewRightArrowBackGround.isHidden = false
        viewLeftArrowBackGround.isHidden = false
        if currentPage == 0 {
            viewRightArrowBackGround.isHidden = false
            viewLeftArrowBackGround.isHidden = true
        }
        if currentPage == (galleryRecentPhotos?.count ?? 0)-1 {
            viewRightArrowBackGround.isHidden = true
            viewLeftArrowBackGround.isHidden = false
        }
    }
}
