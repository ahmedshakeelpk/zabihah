//
//  AppColors.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 03/07/2024.
//

import Foundation
import UIKit

extension UIColor {
    // Ma Colors
    static let clrApp = UIColor(hexString: "990001")
    static let clrBorder = UIColor(hexString: "D0D5DD")
    
    
    static let clrLightBlue = UIColor(hexString: "364152")
    static let clrUnselected = UIColor(hexString: "F8FAFC")

    static let clrDarkBlue = UIColor(hexString: "101828")
    static let clrDarkBlueWithOccupacy05 = UIColor(hexString: "CDD5DF", alpha: 0.5)

    //StatusBar Colors
    static let clrMehroonStatusBar = UIColor(hexString: "8C1B11")
    static let clrWhiteStatusBar = UIColor(hexString: "FFFFFF")
    

    
    static let clrOrange = UIColor(hexString: "F19434")
    static let clrLightRed = UIColor(hexString: "EE6266")
    static let clrLightGray = UIColor(hexString: "E5E5E5")
    static let clrBlack = UIColor(hexString: "202734")
    static let clrGreen = UIColor(hexString: "00CC96")
    static let clrGreen2nd = UIColor(hexString: "ABEFC6")
    static let clrLightGreen = UIColor(hexString: "ECFDF3")
//    static let clrLightGreen = UIColor(hexString: "70d478")
    static let clrDarkGreen = UIColor(hexString: "5cc99a")
    static let clrTextNormal = UIColor(hexString: "202734")
    static let clrGray = UIColor(hexString: "555555")


    static let clrOrangeWithOccupacy10 = UIColor(hexString: "F19434", alpha: 0.10)
    static let clrOrangeWithOccupacy20 = UIColor(hexString: "F19434", alpha: 0.20)

    static let clrGrayWithOccupacy20 = UIColor(hexString: "555555", alpha: 0.20)
    static let clrLightGrayCalendarWithOccupacy05 = UIColor(hexString: "8F92A1", alpha: 0.05)
    
    convenience init(hexString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}
