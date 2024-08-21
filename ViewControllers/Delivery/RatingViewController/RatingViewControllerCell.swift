//
//  RatingViewControllerCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 20/08/2024.
//

import UIKit
import Cosmos

class RatingViewControllerCell: UITableViewCell {
    @IBOutlet weak var viewBackGroundImages: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var viewStarCosmo: CosmosView!
    @IBOutlet weak var viewBackGround: UIView!
    
    var didSelectItemHandler: ((Int) -> ())!
    var galleryRecentPhotos: [String]! {
        didSet {
            viewBackGroundImages.isHidden = !(galleryRecentPhotos.count > 0)
            collectionView.reloadData()
        }
    }

    var reviewDatum: RatingViewController.ReviewDatum!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        viewBackGround.radius(radius: 12)
        GalleryViewControllerCell.register(collectionView: collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        
        labelTitle.text = reviewDatum.userName ?? ""
        labelComments.text = reviewDatum.description ?? ""
        labelTime.text = reviewDatum.period ?? ""
        viewStarCosmo.rating = Double(reviewDatum.rating ?? 0)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryViewControllerCell", for: indexPath) as! GalleryViewControllerCell
        DispatchQueue.main.async {
            cell.imageViewGalleryImage.setImage(urlString: self.galleryRecentPhotos[indexPath.row], placeHolderIcon: "placeHolderFoodItem")
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
