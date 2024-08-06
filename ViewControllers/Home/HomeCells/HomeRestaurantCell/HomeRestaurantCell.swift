//
//  HomeRestaurantCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

class HomeRestaurantCell: HomeBaseCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var buttonFavouriteHandler: (() -> ())!
    var dataRecord: HomeBaseCell.HomeListItem! {
        didSet {
            
        }
    }
    var restuarantResponseData: [HomeViewController.ModelRestuarantResponseData]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        HomeRestaurantSubCell.register(collectionView: collectionView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    override func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        super.updateCell(data: data, indexPath: indexPath, viewController: viewController)
        dataRecord = data as? HomeBaseCell.HomeListItem
        restuarantResponseData = dataRecord.data as? [HomeViewController.ModelRestuarantResponseData]
        collectionView.reloadData()
    }
}

extension HomeRestaurantCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/1.3
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restuarantResponseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRestaurantSubCell.nibName(), for: indexPath) as! HomeRestaurantSubCell
        if self.indexPath != nil {
            cell.indexPath = indexPath
            cell.buttonFavouriteHandler = buttonFavouriteHandler
            cell.viewController = viewController
            cell.modelFeaturedRestuarantResponseData = self.restuarantResponseData?[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
//        (cell as! HomeRestaurantSubCell).setData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}
