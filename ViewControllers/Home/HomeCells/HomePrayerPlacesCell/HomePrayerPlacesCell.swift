//
//  HomePrayerSpacesCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 10/07/2024.
//

import UIKit

class HomePrayerPlacesCell: HomeBaseCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataRecord: HomeBaseCell.HomeListItem! {
        didSet {
            
        }
    }
    var buttonFavouriteHandler: (() -> ())!
    var modelMosqueResponseData: [HomeViewController.ModelRestuarantResponseData]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        HomePrayerSpacesSubCell.register(collectionView: collectionView)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        super.updateCell(data: data, indexPath: indexPath, viewController: viewController)
        
        dataRecord = data as? HomeBaseCell.HomeListItem
        modelMosqueResponseData = dataRecord.data as? [HomeViewController.ModelRestuarantResponseData]
        collectionView.reloadData()
    }
    
    func navigateToDeliveryDetailsViewController(indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController3") as! DeliveryDetailsViewController3
        vc.delegate = viewController as? any DeliveryDetailsViewController3Delegate
        vc.isPrayerPlace = true
        vc.indexPath = indexPath
        vc.selectedMenuCell = (viewController as? HomeViewController)?.selectedMenuCell
        vc.userLocation = (viewController as? HomeViewController)?.userLocation
        vc.modelRestuarantResponseData = modelMosqueResponseData[indexPath.row]
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomePrayerPlacesCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/1.5
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelMosqueResponseData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePrayerSpacesSubCell.nibName(), for: indexPath) as! HomePrayerSpacesSubCell
        if self.indexPath != nil {
            cell.indexPath = indexPath
            cell.buttonFavouriteHandler = buttonFavouriteHandler
            cell.viewController = viewController
            cell.restuarentResponseModel = self.modelMosqueResponseData?[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //            DispatchQueue.main.async {
        //                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        //            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPathUpdated = IndexPath(row: indexPath.item, section: self.indexPath.section)
        navigateToDeliveryDetailsViewController(indexPath: indexPathUpdated)
    }
}
