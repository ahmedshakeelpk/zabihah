//
//  ViewExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/07/2024.
//

import Foundation
import UIKit

extension UIView {
    
    func circle() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    func radius(radius: CGFloat? = 12, color: UIColor? = nil, borderWidth: CGFloat? = 1) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius!
        if color != nil {
            self.layer.borderColor = color?.cgColor
            self.layer.borderWidth = borderWidth!
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setShadow(radius: CGFloat? = 6){
        self.layer.cornerRadius = radius!
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
    }
    func setShadowThin(radius: CGFloat? = 6){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = radius!
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
