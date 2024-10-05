//
//  LabelExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import Foundation
import UIKit

extension UILabel {
    func setTwoColorWithUnderLine(textFirst: String, textSecond: String, colorFirst: UIColor, colorSecond: UIColor) {
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : colorFirst]
        
        let attrs2 = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : colorSecond,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
        ] as [NSAttributedString.Key : Any]

        let attributedString1 = NSMutableAttributedString(string: textFirst, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string: textSecond, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.attributedText = attributedString1
    }
    
    func setTwoSizeText(textFirst: String, textSecond: String, colorFirst: UIColor? = .clrBlack, colorSecond: UIColor? = .clrBlack) {
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : colorFirst]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : colorFirst]

        let attributedString1 = NSMutableAttributedString(string: textFirst, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string: textSecond, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.attributedText = attributedString1
        
//        let labelAttributedText = self.attributedText!
//        let mutableAttributedString = NSMutableAttributedString(attributedString: labelAttributedText)
//        let range = mutableAttributedString.mutableString.range(of: textSecond)
//        mutableAttributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 21), range: range)
//        self.attributedText = mutableAttributedString
    }
}

extension UILabel {
    func linesCount() -> Int {
        let textSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(self.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
}


extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
