//
//  SideMenuView2.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import Foundation

class SideMenuView: UIView {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    var closeMenuHandler: ((IndexPath) -> ())!
    var viewController = UIViewController()

    var arrayTitle = ["Your profile", "Your addresses","Your payment methods"]
    var arrayTitleIcon = ["userProfileSideMenu", "locationSideMenu","paymentSideMenu"]
    var arrayOther = ["Your reviews", "Your favorite places","Buy it again", "Logout"]
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
        
        switch indexPath.row {
        case 0:
            navigateToAddressesViewController()
        case 1:
            navigateToAddressesViewController()
        default:
            print("swith default action")
        }
    }
    func navigateToProfileViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.profile.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
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
        

        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        else {
            // it will fix from properties of table view
        }
        
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
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
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0;
        }
        else {
            return 170
        }
    }
}
