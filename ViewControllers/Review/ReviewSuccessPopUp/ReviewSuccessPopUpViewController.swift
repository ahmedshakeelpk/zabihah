//
//  ReviewSuccessPopUpViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 13/09/2024.
//

import UIKit

class ReviewSuccessPopUpViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewCollectionViewBackGround: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    
    var didCloseTappedHandler: (() -> ())!
    var arrayGalleryImages: [String]? = []
    var isPrayerPlace: Bool = false
    var isReview: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RecentPhotoCell.register(collectionView: collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        viewCollectionViewBackGround.isHidden = arrayGalleryImages?.count ?? 0 == 0

        if isReview {
            labelDescription.text = "Thank you submitting this review.\nWe will approve it shortly."
        }
        else {
            labelDescription.text = "Thank you submitting the photos.\nWe will approve it shortly."
        }
    }
    
    @IBAction func buttonClose(_ sender: Any) {
        self.dismiss(animated: true)
        didCloseTappedHandler?()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReviewSuccessPopUpViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12 )
    //    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayGalleryImages?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3.4
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
        cell.stackViewBackGround.radius(radius: 12, color: .lightGray, borderWidth: 1)
        cell.imageViewPhoto.setImage(urlString: arrayGalleryImages?[indexPath.item] ?? "", placeHolderIcon: isPrayerPlace ? "placeholderMosque" : "placeholderRestaurantSubIcon")
        cell.indexPath = indexPath
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //            DispatchQueue.main.async {
        //                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        //            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
////            openGallary()
//            ImagePickerManager().pickImage(self){ image in
//                    //here is the image
//                if self.arrayLocalGallery == nil {
//                    self.arrayLocalGallery = [UIImage]()
//                }
//                self.arrayLocalGallery?.append(image)
//            }
//        }
//        else {
//            navigateToAddAddressViewController()
//        }
    }
}
