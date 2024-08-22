//
//  ReviewsViewControllerCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 22/08/2024.
//

import UIKit

class ReviewsViewControllerCell: UITableViewCell {
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewButtonDeleteBackGround: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var viewGalleryBackGround: UIView!
    
    var index: Int!
    var buttonDeleteHandler: ((Int) -> ())!
    var buttonEditHandler: ((Int) -> ())!
    var buttonCheckHandler: ((Int) -> ())!
    var didSelectItemHandler: ((Int) -> ())!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var galleryRecentPhotos: [String]! {
        didSet {
            viewGalleryBackGround.isHidden = !(galleryRecentPhotos.count > 0)
            collectionView.reloadData()
        }
    }
    
    var reviewDatum: ReviewsViewController.ReviewDatum? {
        didSet {
            labelTitle.text = reviewDatum?.name ?? ""
            labelAddress.text = reviewDatum?.address ?? ""
            imageViewRestaurant.setImage(urlString: reviewDatum?.iconImage ?? "", placeHolderIcon: "placeholderRestaurantSubIcon")
            galleryRecentPhotos = reviewDatum?.images ?? []
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        
        viewBackGroundForRadius.setShadow()
        stackViewBackGround.radius(radius: 12)
        RecentPhotoCell.register(collectionView: collectionView)
        imageViewRestaurant.circle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    @IBAction func buttonDelete(_ sender: UIButton) {
        buttonDeleteHandler?(index)
    }
    @IBAction func buttonEdit(_ sender: UIButton) {
        buttonEditHandler?(index)
    }
    @IBAction func buttonCheck(_ sender: Any) {
        buttonCheckHandler?(index)
    }
    
}

extension ReviewsViewControllerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12 )
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (galleryRecentPhotos.count > 0) ? 45 : 0, height: (galleryRecentPhotos.count > 0) ? 45 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryRecentPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
        DispatchQueue.main.async {
            cell.imageViewPhoto.setImage(urlString: self.galleryRecentPhotos[indexPath.row], placeHolderIcon: "placeHolderFoodItem")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //            DispatchQueue.main.async {
        //                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        //            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemHandler?(indexPath.row)
    }
}
