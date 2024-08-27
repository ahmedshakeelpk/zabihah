//
//  ReviewsViewControllerCell.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 22/08/2024.
//

import UIKit
import Cosmos

class ReviewsViewControllerCell: UITableViewCell {
    @IBOutlet weak var viewStarRating: CosmosView!
    @IBOutlet weak var labelTimeAgo: UILabel!
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewButtonDeleteBackGround: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var viewGalleryBackGround: UIView!
    
    var isShowCompleteText = false

    var index: Int!
    var buttonDeleteHandler: ((Int) -> ())!
    var buttonEditHandler: ((Int) -> ())!
    var buttonCheckHandler: ((Int) -> ())!
    var didSelectItemHandler: ((Int) -> ())!
    var tapOnViewMoreHandler: ((Int) -> ())!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var galleryRecentPhotos: [String]! {
        didSet {
            viewGalleryBackGround.isHidden = !(galleryRecentPhotos.count > 0)
            collectionView.reloadData()
        }
    }
    
    var reviewDatum: ReviewsViewController.ReviewDatum? {
        didSet {
            labelTitle.text = reviewDatum?.userName ?? ""
            labelAddress.text = reviewDatum?.address ?? ""
            labelTimeAgo.text = reviewDatum?.period ?? ""

            loadLabelCommentData()
            viewStarRating.rating = reviewDatum?.rating ?? 0
            imageViewRestaurant.setImage(urlString: reviewDatum?.iconImage ?? "", placeHolderIcon: "placeholderRestaurantSubIcon")
            galleryRecentPhotos = reviewDatum?.images ?? []
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        
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
    
    
    
    func loadLabelCommentData() {
        labelComment.text = reviewDatum?.description ?? ""
        if labelComment.linesCount() > 3 {
            updateTextInLabel()
        }
    }
    
    func setLabelFontSize(completeText: String, changeText: String) {
        let text = NSMutableAttributedString(
            string: completeText
        )
        let range = text.mutableString.range(of: "View More")

        if range.location != NSNotFound {
            text.addAttribute(.font,
                              value: UIFont.systemFont(ofSize: 14),
                              range: range)
        }
    }
    
    private func updateTextInLabel() {
        let fullText = labelComment.text!
        let truncatedText = truncateTextToThreeLines(text: fullText)
        
        let viewMoreText =  isShowCompleteText ? " ... View Less" : "... View More"
        
        let fullString = NSMutableAttributedString(string: truncatedText)
        let viewMoreAttributedString = NSAttributedString(
            string: viewMoreText,
            attributes: [
                .foregroundColor: UIColor.colorApp,
                .font: UIFont.systemFont(ofSize: 12, weight: .heavy)
            ]
        )
        fullString.append(viewMoreAttributedString)
        
        let range = fullString.mutableString.range(of: "... View More")

        if range.location != NSNotFound {
            fullString.addAttribute(.font,
                              value: UIFont.systemFont(ofSize: 12, weight: .heavy),
                              range: range)
        }
        
        labelComment.attributedText = fullString
        labelComment.isUserInteractionEnabled = true
        labelComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMoreTapped)))
    }
    
    @objc func viewMoreTapped() {
        // Handle the "View More" tap, e.g., expand the label or navigate to a detailed view
        print("View More tapped")
        isShowCompleteText.toggle()
        loadLabelCommentData()
        tapOnViewMoreHandler?(index)
    }
    private func truncateTextToThreeLines(text: String) -> String {
        let maxLines = isShowCompleteText ? 10 : 2.8
        let font = labelComment.font
        let lineHeight = font?.lineHeight
        let maxHeight = (lineHeight ?? 11) * CGFloat(maxLines)
        
        let size = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        var truncatedText = text
        
        while truncatedText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height > maxHeight && truncatedText.count > 0 {
            truncatedText = String(truncatedText.dropLast())
        }
        
        return truncatedText.trimmingCharacters(in: .whitespacesAndNewlines)
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
        didSelectItemHandler?(index)
    }
}
