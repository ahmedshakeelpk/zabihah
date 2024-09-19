//
//  GalleryViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/08/2024.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewLeftArrowBackGround: UIView!
    @IBOutlet weak var viewRightArrowBackGround: UIView!
    @IBOutlet weak var buttonRight: UIButton!
    
    @IBOutlet weak var viewCountBackGround: UIView!
    @IBOutlet weak var labelImageCount: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonLeft: UIButton!
    
    var galleryRecentPhotos: [String?]?
    var totalImages = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        totalImages = galleryRecentPhotos?.count ?? 0
        // Do any additional setup after loading the view.
        GalleryViewControllerCell.register(collectionView: collectionView)
        
        labelImageCount.text = "\(1)/\(totalImages)"
        viewCountBackGround.circle()
        viewLeftArrowBackGround.circle()
        viewRightArrowBackGround.circle()
        viewLeftArrowBackGround.isHidden = true
        if totalImages == 1 {
            viewLeftArrowBackGround.isHidden = true
            viewRightArrowBackGround.isHidden = true
        }
    }
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func buttonLeft(_ sender: Any) {
        leftArrowTapped()
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
        
        let currentPage:Int = indexPath.item
        labelImageCount.text = "\(currentPage+1)/\(totalImages)"
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
