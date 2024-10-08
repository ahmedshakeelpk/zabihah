//
//  ImageViewExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 30/07/2024.
//

import UIKit

extension UIImageView {
    func setImage(urlString: String, placeHolderIcon: String? = nil, completion: ((UIImage?) -> Void)? = nil) {
        
        self.image = nil
        self.kf.setImage(with: URL(string: urlString), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
                self.image = value.image
                completion?(value.image)
            case .failure(let error):
                print("Error: \(error)")
                if let icon = placeHolderIcon {
                    self.image = UIImage(named: icon)
                }
                completion?(nil)
            }
        })
    }
}
