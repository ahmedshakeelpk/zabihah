//
//  TextFieldExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 09/07/2024.
//

import UIKit

extension UITextField {
    
    func placeHolderColor(color: UIColor? = UIColor.lightGray) {
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color!]
        )
    }
    
}
