//
//  ViewControllerExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 04/07/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func setStatusBarTopColor(color: UIColor) {
     let colouredTopBlack = UIView()
     view.addSubview(colouredTopBlack)
     colouredTopBlack.translatesAutoresizingMaskIntoConstraints = false
     colouredTopBlack.backgroundColor = color

     NSLayoutConstraint.activate([
        colouredTopBlack.topAnchor.constraint(equalTo: view.topAnchor),
        colouredTopBlack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        colouredTopBlack.widthAnchor.constraint(equalTo: view.widthAnchor),
    ])
  }
}

extension UIViewController {
//    func pushViewController(toStoryboard: StoryBoard.name, toViewController: T) {
//        let vc = UIStoryboard.init(name: toStoryboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: "NanoLoanHistoryDetails") as! NanoLoanHistoryDetails
//        vc.modelCurrentLoan = modelGetActiveLoan?.data?.loanHistory[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    public func showActivityIndicator2() {
        customActivityIndicatory(self.view, startAnimate: true)
    }
    
    public func hideActivityIndicator2() {
        customActivityIndicatory(self.view, startAnimate: false)
    }
}

extension UIViewController {
    func showAlertCustomPopup(title:String? = "", message: String? = "", iconName: IconNames.iconNameError = .iconError, buttonNames: [[String: AnyObject]]? = [[
        "buttonName": "OKAY",
        "buttonBackGroundColor": UIColor.colorOrange,
        "buttonTextColor": UIColor.white] as [String : Any]] as? [[String: AnyObject]]
//    ) {
                              , completion: ((String?) -> Void)? = nil) {
            
        let alertCustomPopup = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "AlertPopupMessage") as! AlertPopupMessage
        alertCustomPopup.titleMessage = title ?? ""
        alertCustomPopup.message = message ?? ""
        alertCustomPopup.arrayButtonNames = buttonNames!
        alertCustomPopup.iconName = iconName.rawValue
        
        alertCustomPopup.modalPresentationStyle = .overFullScreen
        
        alertCustomPopup.complitionButtonAction = { buttonName in
            completion?(buttonName)
        }
        
        self.present(alertCustomPopup, animated: true)
    }
    
    func showEmptyView(message: String? = "", iconName: String? = nil, buttonName: String? = "OK", complition: @escaping(_ actionCall: Bool, _ emptyView: UIView) -> Void) {
        
//        , completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
            
        let emptyVC = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
        emptyVC.messageDescription = message!
        emptyVC.buttonName = buttonName!
        emptyVC.iconName = iconName!
        emptyVC.callBackButtonAction = {
            complition(true, emptyVC.view)
        }
        emptyVC.view.frame = self.view.frame
        self.view.addSubview(emptyVC.view)
        
//        emptyVC.modalPresentationStyle = .overFullScreen
//        self.present(emptyVC, animated: false)
    }

    
    func popToViewController<T>(viewController: T) -> UIViewController? {
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: viewController.self as! AnyClass) {
                DispatchQueue.main.async {
                    self.navigationController!.popToViewController(controller, animated: true)
                }
                return controller
                break
            }
        }
        return nil
        //        for controller in self.navigationController!.viewControllers as Array {
        //                        if controller.isKind(of: ProfileViewController.self) {
        //                            if let targetViewController = controller as? ProfileViewController {
        //                                targetViewController.getuser()
        //                                self.navigationController!.popToViewController(controller, animated: true)
        //                            }
        //                            break
        //                        }
        //                    }
    }
    
}
extension UIViewController {
    
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
                   return window
        }
        
//        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
//        return window
        return UIWindow()
        
    }
}
extension UIViewController {
        var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return nil }
         return delegate
    }
}

extension UIViewController {
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: 150, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
//    func showToast(message: String, duration: TimeInterval = 2.0) {
//        let toastLabel = UILabel()
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center
//        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
//        toastLabel.text = message
//        toastLabel.numberOfLines = 0
//        toastLabel.translatesAutoresizingMaskIntoConstraints = false
//        toastLabel.alpha = 0.0
//        
//        self.view.addSubview(toastLabel)
//        
//        let horizontalPadding: CGFloat = 20.0
//        let verticalPadding: CGFloat = 40.0
//        
//        NSLayoutConstraint.activate([
//            toastLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontalPadding),
//            toastLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -horizontalPadding),
//            toastLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0)
//        ])
//        
//        
//        // Layout toastLabel to get its height dynamically
////        toastLabel.layoutIfNeeded()
//        
//        UIView.animate(withDuration: 0.5, animations: {
//            toastLabel.alpha = 1.0
//        }) { _ in
//            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
//                toastLabel.alpha = 0.0
//            }) { _ in
//                toastLabel.removeFromSuperview()
//            }
//        }
//    }
}

extension UIViewController {
    func itself<T>(_ value: T) -> T {
        return value
    }
    
    func dialNumber(number : String, isActionSheet: Bool? = nil, completion: ((String?) -> Void)? = nil) {
        if isActionSheet ?? false {
            if number == "" {
                completion?("viewdetails")
            }
            else {
                actionSheetForCall(number: number) {clickOn in
                    if clickOn == "viewdetails" {
                        completion?(clickOn)
                    }
                }
            }
        }
        else {
            self.callNow(number: number) {actionType in
                completion?(actionType)
            }
        }
    }
    func callNow(number : String, completion: ((String?) -> Void)? = nil) {
        let updatedPhone = number.filter{$0.isNumber}
        if let url = URL(string: "tel://\(updatedPhone)"),
           UIApplication.shared.canOpenURL(url) {
            completion?("callnow")
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
            self.showToast(message: "Invalid Number")
        }
    }
    //Mark:- Choose Action Sheet
    func actionSheetForCall(number : String, completion: ((String?) -> Void)? = nil) {
        var myActionSheet = UIAlertController(title: "Details!", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        myActionSheet.view.tintColor = UIColor.black
        let callAction = UIAlertAction(title: "Call", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.callNow(number: number)
        })
        let viewDetailsAction = UIAlertAction(title: "View Details", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            completion?("viewdetails")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if IPAD {
            //In iPad Change Rect to position Popover
            myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        }
        myActionSheet.addAction(callAction)
        myActionSheet.addAction(viewDetailsAction)
        myActionSheet.addAction(cancelAction)
        self.present(myActionSheet, animated: true, completion: nil)
    }
}
