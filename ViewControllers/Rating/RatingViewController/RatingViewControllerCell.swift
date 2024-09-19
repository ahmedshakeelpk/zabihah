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
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelTimeAgo: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewButtonDeleteBackGround: UIView!
    @IBOutlet weak var labelViewMore: UILabel!

    @IBOutlet weak var viewBackGroundForRadius: UIView!
    @IBOutlet weak var stackViewBackGround: UIStackView!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var viewGalleryBackGround: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var isShowCompleteText = false
    var index: Int!
    var didSelectItemHandler: ((Int) -> ())!
    var didTapOnViewMoreOrViewLess: ((Int) -> ())!

    
    var galleryRecentPhotos: [String?]? {
        didSet {
            viewGalleryBackGround.isHidden = !(galleryRecentPhotos?.count ?? 0 > 0)
            collectionView.reloadData()
        }
    }
    
    var modelGetReviewData: HomeViewController.Review? {
        didSet {
            labelTitle.text = "\(modelGetReviewData?.user?.firstName ?? "") \(modelGetReviewData?.user?.lastName ?? "")"
            labelAddress.text = modelGetReviewData?.place?.address ?? ""
            labelAddress.isHidden = true
            labelComment.text = modelGetReviewData?.comment ?? ""
            let dateString = modelGetReviewData?.updatedOn ?? ""
            labelTimeAgo.text = timeAgo(from: dateString)
            viewStarRating.rating = Double(modelGetReviewData?.rating ?? 0)
            loadLabelCommentData()

            galleryRecentPhotos = modelGetReviewData?.photoWebUrls ?? []
//            labelViewMore.isHidden = !(labelComment.linesCount() > 3)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        viewBackGroundForRadius.setShadow()
        stackViewBackGround.radius(radius: 12)
        RecentPhotoCell.register(collectionView: collectionView)
        labelComment.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func loadLabelCommentData() {
        labelComment.numberOfLines = 0
        labelComment.text = modelGetReviewData?.comment ?? ""
        if isSelectedCell {
            return()
        }
        if labelComment.linesCount() > 3 {
            setLabelTextInThreeLine(text: modelGetReviewData?.comment ?? "", label: labelComment)
        }
    }
    
    func setLabelTextInThreeLine(text: String, label: UILabel) {
        label.numberOfLines = 3
        let fullText = text
        let ellipsisText = "… "
        let moreText = "more"

        // Truncate the text to a maximum length, considering ellipsis and "more"
        let maxLength = 150
        let truncatedText = (fullText as NSString).substring(with: NSRange(location: 0, length: min(fullText.count, maxLength)))

        // Create attributed string with truncated text
        let attributedString = NSMutableAttributedString(string: truncatedText)

        // Create attributed string for the "…" part (no underline)
        let ellipsisAttributedString = NSAttributedString(string: ellipsisText)

        // Create attributed string for the "more" text with underline
        let moreAttributedString = NSMutableAttributedString(
            string: moreText,
            attributes: [
                .foregroundColor: UIColor.colorApp, // Custom color
                .font: UIFont.systemFont(ofSize: 12, weight: .bold),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        // Append the "…" and "more" attributed strings to the truncated text
        attributedString.append(ellipsisAttributedString)
        attributedString.append(moreAttributedString)

        // Set the final attributed text to the label
        label.attributedText = attributedString

        // Enable user interaction for tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewMoreTapped(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
    }

    var isSelectedCell = false
    @objc func viewMoreTapped(_ sender: UITapGestureRecognizer) {
        isSelectedCell = true
        print("More tapped with text: \(modelGetReviewData?.comment ?? "")")
        // Expanding the label and setting the full text
//        labelComment.text = modelGetReviewData?.comment ?? ""
        setLabelTextInFullText(text: modelGetReviewData?.comment ?? "", label: labelComment)
        didTapOnViewMoreOrViewLess(index)
    }
    func setLabelTextInFullText(text: String, label: UILabel) {
        labelComment.numberOfLines = 0
        let fullText = text
//        let moreText = "… View Less"
        let moreText = ""
        
        let truncatedText = (fullText as NSString).substring(with: NSRange(location: 0, length: min(fullText.count, fullText.count)))
        
        let attributedString = NSMutableAttributedString(string: truncatedText)
        let moreAttributedString = NSMutableAttributedString(string: moreText, attributes: [.foregroundColor: UIColor.colorApp, .font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        
        attributedString.append(moreAttributedString)
        
        label.attributedText = attributedString
        
        // Enable user interaction for tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewLessTapped(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewLessTapped(_ sender: UITapGestureRecognizer) {
        return()
        print("More tapped with text: \(modelGetReviewData?.comment ?? "")")
        setLabelTextInThreeLine(text: modelGetReviewData?.comment ?? "", label: labelComment)
        
        didTapOnViewMoreOrViewLess(index)
    }
}

extension RatingViewControllerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12 )
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (galleryRecentPhotos?.count ?? 0 > 0) ? 45 : 0, height: (galleryRecentPhotos?.count ?? 0 > 0) ? 45 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryRecentPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPhotoCell", for: indexPath) as! RecentPhotoCell
        DispatchQueue.main.async {
            cell.imageViewPhoto.setImage(urlString: self.galleryRecentPhotos?[indexPath.row] ?? "", placeHolderIcon: "placeHolderFoodItem")
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
