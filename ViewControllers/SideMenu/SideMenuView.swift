//
//  SideMenuView2.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import Foundation
import Kingfisher
import Alamofire

class SideMenuView: UIView {
    
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var viewButtonEditBackGround: UIView!

    var closeMenuHandler: ((IndexPath) -> ())!
    var viewController = UIViewController()

    var arrayTitle = ["Your profile", "Your addresses","Your payment methods"]
    var arrayTitleIcon = ["placeHolderUser", "locationSideMenu","paymentSideMenu"]
    var arrayOther = ["Your reviews", "Your favorite places","Buy it again", "Log out"]
    var arrayOtherIcon = ["reviewSideMenu", "favouriteSideMenu","buySideMenu", "logoutSideMenu"]
    var buttonBackHandler: (() -> ())!
    
    
    var contentView: UIView!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    //MARK:
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //            loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //            loadViewFromNib()
        self.sideMenuIntiliziation()
    }
    
    
    
    //MARK:
    //        func loadViewFromNib() {
    //            let bundle = Bundle(for: UIViewFromNib.self)
    //            contentView = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: self).first as? UIView
    //            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //            contentView.frame = bounds
    //            addSubview(contentView)
    //        }
    
    @IBAction func buttonBack(_ sender: Any) {
        buttonBackHandler?()
    }

    func navigateToViewController(indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                navigateToProfileViewController()
            case 1:
                navigateToAddressesListViewController()
            case 2:
                print("index 2")
            default:
                print("swith default action")
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("case 1")
                navigateToReviewsViewController()
            case 1:
                print("case 2")
                navigateToMyFavouritesViewController()
            case 3:
                actionSheetLogout()
            default:
                print("swith default action")
            }
        }
        
    }
    
    func removeCacheData() {
        kAccessToken = ""
        kDefaults.setValue(nil, forKey: "kAccessToken")
        let dictionary = kDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            kDefaults.removeObject(forKey: key)
        }
        kDefaults.synchronize()
    }
    //Mark:- Choose Image Method
    func actionSheetLogout() {
        var myActionSheet = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.actionSheet)
        myActionSheet.view.tintColor = UIColor.black
        let galleryAction = UIAlertAction(title: "Logout", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.removeCacheData()
            DispatchQueue.main.async {
                self.navigateToRootLoginViewController()
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if IPAD {
            //In iPad Change Rect to position Popover
            myActionSheet = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        }
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cancelAction)
        viewController.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
    func navigateToRootLoginViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryBoard.name.login.rawValue, bundle:nil)
        if let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationLoginViewController") as? UINavigationController {
            viewController.sceneDelegate?.window?.rootViewController = navigationController
        }
    }
    func navigateToProfileViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddressesListViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddressesListViewController") as! AddressesListViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToReviewsViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.delivery.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToFAQsViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.faqs.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FAQsListViewController") as! FAQsListViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToMyFavouritesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.myFavourites.rawValue, bundle: nil).instantiateViewController(withIdentifier: "MyFavouritesViewController") as! MyFavouritesViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setData() {
        if kModelGetUserProfileResponse?.email == nil && kModelGetUserProfileResponse?.phone == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.getuser()
            }
            return
        }
                
        labelFullName.text = "\(kModelGetUserProfileResponse?.firstName ?? "") \(kModelGetUserProfileResponse?.lastName ?? "")"
        labelAddress.text = kModelGetUserProfileResponse?.email ?? ""
        getProfilePicture() {
            profilePicture in
            self.imageViewProfile.setImageProfile(urlString: profilePicture!, placeHolderIcon: "placeHolderUser")
        }
    }
    
    var modelGetUserResponseLocal: HomeViewController.ModelGetUserProfileResponse? {
        didSet {
            DispatchQueue.main.async {
                kModelGetUserProfileResponse = self.modelGetUserResponseLocal
                NotificationCenter.default.post(name: Notification.Name("kUserProfileUpdate"), object: nil)
            }
        }
    }
    
    func getuser() {
        APIs.postAPI(apiName: .mySelf, methodType: .get, encoding: JSONEncoding.default) { responseData, success, errorMsg, statusCode in
            print(responseData ?? "")
            print(success)
            let model: HomeViewController.ModelGetUserProfileResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
        }
    }
    
    @IBOutlet weak var viewProfileImageBackGround: UIView!
    func sideMenuIntiliziation() {
        if tableView == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // your code here
                self.sideMenuIntiliziation()
            }
            return
        }
        SideMenuViewCell.register(tableView: tableView)
        SideMenuViewHeaderViewCell.register(tableView: tableView)
        SideMenuViewFooterViewCell.register(tableView: tableView)
        viewButtonEditBackGround.radius(radius: 8, color: .lightGray, borderWidth: 1)
        
        imageViewProfile.radius(radius: imageViewProfile.frame.height / 2, color: .white, borderWidth: 4)
        viewProfileImageBackGround.setShadow(radius: viewProfileImageBackGround.frame.height / 2)

        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        else {
            // it will fix from properties of table view
        }
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData), name: Notification.Name("kUserProfileUpdate"), object: nil)
        
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    func buttonAboutHandler() {
        navigateToAboutUs()
    }
    func buttonPrivacyPolicyHandler() {
        navigateToPrivacyPolicy()
    }
    func buttonFrequentlyAskQuestionHandler() {
        navigateToFAQsViewController()
    }

    
    func navigateToAboutUs() {
        let urlString = "https://www.zabihah.com/app/about"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        else {
//            showToast(message: "invalid social link please update in your profile")
        }
    }
    func navigateToPrivacyPolicy() {
        let urlString = "https://www.zabihah.com/app/privacy"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        else {
//            showToast(message: "invalid social link please update in your profile")
        }
    }
    func navigateToTermsAndConditions() {
        let urlString = "https://www.zabihah.com/com/tos"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        else {
//            showToast(message: "invalid social link please update in your profile")
        }
    }

    
}


extension SideMenuView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayTitle.count
        }
        else {
            return arrayOther.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewCell") as! SideMenuViewCell
        if indexPath.section == 0 {
            cell.setData(indexPath: indexPath, nameTitle: arrayTitle[indexPath.row], iconTitle: arrayTitleIcon[indexPath.row])        }
        else {
            cell.setData(indexPath: indexPath, nameTitle: arrayOther[indexPath.row], iconTitle: arrayOtherIcon[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        var titleName = ""
        if indexPath.section == 0 {
            titleName = arrayTitle[indexPath.row]
        }
        else {
            titleName = arrayOther[indexPath.row]
        }
        if titleName.lowercased() == "Buy it again".lowercased() || titleName.lowercased() == "Your payment methods".lowercased() {
            return()
        }
        
        closeMenuHandler?(indexPath)
        navigateToViewController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        else {
            if let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuViewHeaderViewCell") as? SideMenuViewHeaderViewCell {
                if let titleLabel = myHeader.labelTitle {
                    titleLabel.text = "Others"
                }
                return myHeader
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        else {
            if let myFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuViewFooterViewCell") as? SideMenuViewFooterViewCell {
                myFooter.buttonFrequentlyAskQuestionHandler = buttonFrequentlyAskQuestionHandler
                myFooter.buttonPrivacyPolicyHandler = buttonPrivacyPolicyHandler
                myFooter.buttonAboutHandler = buttonAboutHandler
                return myFooter
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0;
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0;
        }
        else {
            return 250
        }
    }
}


//var modelUserProfilePictureResponse: ModelUserProfilePictureResponse {
//    didSet {
//        
//    }
//}
func getProfilePicture(completion: @escaping(String?) -> Void?) {
    APIs.postAPI(apiName: .profilePicture, methodType: .get, encoding: JSONEncoding.default) { responseData, success, errorMsg, statusCode in
        print(responseData ?? "")
        print(success)
        if statusCode == 200 {
            let model: ModelUserProfilePictureResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelUserProfilePictureResponse = model!
            completion(model?.uri)
        }
    }
}
struct ModelUserProfilePictureResponse: Codable {
    let uri: String
}
