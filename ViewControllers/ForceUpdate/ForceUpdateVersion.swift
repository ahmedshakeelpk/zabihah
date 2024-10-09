//
//  ForceUpdateVersion.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/10/2024.
//

import Foundation
import UIKit

class ForceUpdateVersion {
    
    var APP_ID = "id325383348"
    var viewController: UIViewController?
    
    func checkAppVersionAndUpdate(requiredVersion: String, viewController: UIViewController, isForceUpdate: Bool) {
        // Get the current app version
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            // Compare current version with required version
            if currentVersion.compare(requiredVersion, options: .numeric) == .orderedAscending {
                // Show force update alert if the current version is less than the required version
                showForceUpdateAlert(viewController: viewController, isForceUpdate: isForceUpdate)
            }
        }
    }
    
    func showForceUpdateAlert(viewController: UIViewController, isForceUpdate: Bool) {
        self.viewController = viewController
        // Create the alert controller
        let alertController = UIAlertController(
            title: "Update Available",
            message: "A new version of this app is available. Please update to continue.",
            preferredStyle: .alert
        )
        
        // Add the "Update" action that redirects the user to the App Store
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/\(self.APP_ID)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        // Add a "Cancel" action to let the user dismiss the alert temporarily
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert controller
        alertController.addAction(updateAction)
        if !isForceUpdate {
            alertController.addAction(cancelAction)
        }
        // Present the alert (assuming `self` is a view controller)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
    }
}
