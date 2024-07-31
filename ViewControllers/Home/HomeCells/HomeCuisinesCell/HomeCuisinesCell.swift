//
//  HomeCuisinesCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 10/07/2024.
//

import UIKit

protocol HomeCuisinesCellDelegate: AnyObject {
    func didSelectRow(indexPath: IndexPath)
}
class HomeCuisinesCell: HomeBaseCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: HomeCuisinesCellDelegate!
    var dataRecord: HomeBaseCell.HomeListItem!
    var modelCuisineResponse: [HomeViewController.ModelCuisine]? {
        didSet {

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        HomeCuisinesSubCell.register(collectionView: collectionView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        dataRecord = data as? HomeBaseCell.HomeListItem
        modelCuisineResponse = dataRecord.data as? [HomeViewController.ModelCuisine]
        collectionView.reloadData()
        delegate = viewController as? any HomeCuisinesCellDelegate
    }
    
    override func updateCell(data: Any?, indexPath: IndexPath, viewController: UIViewController) {
        super.updateCell(data: data, indexPath: indexPath, viewController: viewController)
    }
}

extension HomeCuisinesCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/4.5
        return CGSize(width: width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCuisineResponse?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCuisinesSubCell.nibName(), for: indexPath) as! HomeCuisinesSubCell
        cell.modelCuisine = modelCuisineResponse?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        delegate?.didSelectRow(indexPath: indexPath)
    }
}

