//
//  TableViewExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import Foundation
import UIKit

final class TableViewContentSized: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension UITableView {
    func setEmptyMessage(iconName: String) {
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        
        var backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.center = backgroundView.center
        imageView.frame.origin.y = backgroundView.frame.midX - 50
        backgroundView.addSubview(imageView)
        
        self.backgroundView = backgroundView
    }
    
    func removeEmptyMessage() {
        self.backgroundView = nil
    }
    
}

extension UITableViewCell {
    static func nibName() -> String {
        return String(describing: self.self)
    }
    
    static func register(tableView: UITableView)  {
        let nibName = String(describing: self.self)
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}

extension UITableViewHeaderFooterView {
    static func nibName() -> String {
        return String(describing: self.self)
    }
    static func register(tableView: UITableView)  {
        let nib = UINib(nibName: nibName(), bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: nibName())
    }
}

extension UICollectionViewCell {
    static func nibName() -> String {
        return String(describing: self.self)
    }
    
    static func register(collectionView: UICollectionView)  {
        let nibName = String(describing: self.self)
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}
