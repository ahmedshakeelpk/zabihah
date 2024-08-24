//
//  HomeFoodItemCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

class HomeFoodItemCell: HomeBaseCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var buttonFavouriteHandler: (() -> ())!
    var dataRecord: HomeBaseCell.HomeListItem! {
        didSet {
            
        }
    }
    var modelFeaturedRestuarantResponseData: [HomeViewController.ModelRestuarantResponseData]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        HomeFoodItemSubCell.register(collectionView: collectionView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    override func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        super.updateCell(data: data, indexPath: indexPath, viewController: viewController)
        dataRecord = data as? HomeBaseCell.HomeListItem
        modelFeaturedRestuarantResponseData = dataRecord.data as? [HomeViewController.ModelRestuarantResponseData]
        collectionView.reloadData()
    }
}

extension HomeFoodItemCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/1.3
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelFeaturedRestuarantResponseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFoodItemSubCell.nibName(), for: indexPath) as! HomeFoodItemSubCell
        if self.indexPath != nil {
            cell.indexPath = indexPath
            cell.buttonFavouriteHandler = buttonFavouriteHandler
            cell.viewController = viewController
            cell.modelFeaturedRestuarantResponseData = self.modelFeaturedRestuarantResponseData?[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
//        (cell as! HomeFoodItemSubCell).setData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
//        collectionView.reloadData()
        navigateToDeliveryDetailsViewController(indexPath: indexPath)
    }
    
    func navigateToDeliveryDetailsViewController(indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
        vc.delegate = viewController as? any DeliveryDetailsViewController3Delegate
        vc.indexPath = indexPath
        vc.selectedMenuCell = (viewController as? HomeViewController)?.selectedMenuCell
        vc.userLocation = (viewController as? HomeViewController)?.userLocation
        vc.modelRestuarantResponseData = modelFeaturedRestuarantResponseData[indexPath.row]
        vc.isFeaturedCell = true
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
