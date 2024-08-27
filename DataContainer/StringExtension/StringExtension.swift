//
//  StringExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 31/07/2024.
//

import Foundation
import UIKit

extension String {
    func getIntegerValue() -> String {
        //let okayChars : Set<Character> =
    //            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        let okayChars : Set<Character> =
            Set("1234567890")
        let stringResponseIntegerValuesArray = self.components(separatedBy: ".")
        var stringResponseIntegerValues = ""
        if stringResponseIntegerValuesArray.count > 2 {
            stringResponseIntegerValues = String(stringResponseIntegerValuesArray[1].filter {okayChars.contains($0)})
        }
        else if stringResponseIntegerValuesArray.count > 0 {
            stringResponseIntegerValues = String(stringResponseIntegerValuesArray.first!.filter {okayChars.contains($0)})
        }
    //        return String(self.filter {okayChars.contains($0)})
        return stringResponseIntegerValues
    }
}

