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
        "buttonBackGroundColor": UIColor.clrOrange,
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

    
    func dismissToViewController<T>(viewController: T) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: viewController.self as! AnyClass) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
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
