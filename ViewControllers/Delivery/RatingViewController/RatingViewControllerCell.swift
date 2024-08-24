//
//  RatingViewControllerCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 20/08/2024.
//

import UIKit
import Cosmos



class RatingViewControllerCell: UITableViewCell {
    @IBOutlet weak var viewStarRating: CosmosView!
    @IBOutlet weak var labelTimeAgo: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewButtonDeleteBackGround: UIView!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var viewGalleryBackGround: UIView!
    
    var index: Int!
    var didSelectItemHandler: ((Int) -> ())!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var galleryRecentPhotos: [String]! {
        didSet {
            viewGalleryBackGround.isHidden = !(galleryRecentPhotos.count > 0)
            collectionView.reloadData()
        }
    }
    
    var reviewDatum: RatingViewController.ReviewDatum? {
        didSet {
            labelTitle.text = reviewDatum?.userName ?? ""
            labelComment.text = reviewDatum?.description ?? ""
            labelTimeAgo.text = reviewDatum?.period ?? ""
            viewStarRating.rating = reviewDatum?.rating ?? 0
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

extension RatingViewControllerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        didSelectItemHandler?(index)
    }
}
