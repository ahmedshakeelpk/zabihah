//
//  DeliveryDetailsViewController3.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 28/07/2024.
//

import UIKit

class DeliveryDetailsViewController3: UIViewController {
    @IBOutlet weak var collectionViewRecentPhoto: UICollectionView!
    @IBOutlet weak var collectionViewConnect: UICollectionView!
    @IBOutlet weak var buttonBack: UIView!
    @IBOutlet weak var collectionViewCountry: UICollectionView!
    @IBOutlet weak var collectionViewType: UICollectionView!
    @IBOutlet weak var collectionViewFoodItem: UICollectionView!
    
    @IBOutlet weak var buttonAmenities: UIButton!
    @IBOutlet weak var buttonHalalSummary: UIButton!
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces", "Pickup & delivery", "Prayer spaces"]
    var selectedMenuCell: Int = 0 {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeFoodItemSubSuisineCell.register(collectionView: collectionViewCountry)
        RecentPhotoCell.register(collectionView: collectionViewRecentPhoto)
        SocialConnectCell.register(collectionView: collectionViewConnect)

        collectionViewRecentPhoto.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        collectionViewConnect.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 30)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonAmenities(_ sender: Any) {
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.popViewController(animated: true)
    }
    @IBAction func buttonHalalSummary(_ sender: Any) {
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


extension DeliveryDetailsViewController3: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: collectionViewFoodItem == collectionView ? 0 : 8, bottom: 0, right: collectionViewFoodItem == collectionView ? 0 : 12 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (collectionViewCountry == collectionView) {
            let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 22
            return CGSize(width: width, height: (collectionViewCountry == collectionView) ? 22 : 28)
        }
        else if (collectionViewType == collectionView) {
            let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]).width + 22
            return CGSize(width: width, height: (collectionViewCountry == collectionView) ? 22 : 28)
        }
        else if (collectionViewRecentPhoto == collectionView) {
            let width = collectionView.frame.width / 3.4
            return CGSize(width: 90, height: 90)
        }
        else if (collectionViewConnect == collectionView) {
            let width = collectionView.frame.width / 3.4
            return CGSize(width: 65, height: 65)
        }
        else {
            let width = collectionView.frame.width / 2 - 8
            return CGSize(width: width, height: 240)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionViewCountry == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodItemSubSuisineCell", for: indexPath) as! HomeFoodItemSubSuisineCell
            cell.labelName.text = arrayNames[indexPath.item]
            return cell
        }
        else if (collectionViewType == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCell", for: indexPath) as! HomeMenuCell
            cell.labelName.text = arrayNames[indexPath.item]
            return cell
        }
        else if (collectionViewRecentPhoto == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
            return cell
        }
        else if (collectionViewConnect == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialConnectCell", for: indexPath) as! SocialConnectCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCollectionViewCell", for: indexPath) as! FoodItemCollectionViewCell

            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}
