//
//  GalleryViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 12/08/2024.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var labelImageCount: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var totalImages = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        GalleryViewControllerCell.register(collectionView: collectionView)
        
        labelImageCount.text = "\(1)/\(totalImages)"
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
        return totalImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryViewControllerCell", for: indexPath) as! GalleryViewControllerCell
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
        
        guard
            
            let indexPath:IndexPath = collectionView.indexPathForItem(at:point)
        else
        {
            return
        }
        
        let currentPage:Int = indexPath.item
        labelImageCount.text = "\(currentPage+1)/\(totalImages)"
    }
}
