//
//  HomeViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 06/07/2024.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    @IBOutlet weak var buttonSideMenu: UIButton!
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var stackViewSearchNearLocationBackGround: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackViewSearchNTextFieldNearLocationBackGround: UIStackView!
    @IBOutlet weak var viewSettingBackGround: UIView!
    @IBOutlet weak var stackViewFilterResultBackGround: UIStackView!
    @IBOutlet weak var textFieldFilterResult: UITextField!
    @IBOutlet weak var textFieldSearchLocation: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSearchLocation: UIButton!
    
    var modelGetUserResponseLocal: ModelGetUserResponse? {
        didSet {
            modelGetUserResponse = modelGetUserResponseLocal
        }
    }
    
    private var sideMenu: SideMenu!
    let arrayNames = ["Home", "Find halal food", "Pickup & delivery", "Prayer spaces"]
    let arrayNamesIcon = ["houseWhiteMisc", "briefcaseBlackMisc", "userBlackMisc", "addCircleBlackMisc"]
    var listItems: [HomeBaseCell.HomeListItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getuser()
        // Do any additional setup after loading the view.
        sideMenuSetup()
        stackViewFilterResultBackGround.radius(radius: 8)
        stackViewSearchNearLocationBackGround.radius(radius: 8)
        stackViewSearchNTextFieldNearLocationBackGround.radius(radius: 8)
        viewSettingBackGround.radius(radius: 8)
        setStatusBarTopColor(color: .clrMehroonStatusBar)
        textFieldSearchLocation.placeHolderColor(color: .white)
        HomeMenuCell.register(collectionView: collectionView)

        HomeFoodItemCell.register(tableView: tableView)
        HomeCuisinesCell.register(tableView: tableView)
        HomeSectionHeaderCell.register(tableView: tableView)
        HomePrayerSpacesCell.register(tableView: tableView)
        
        //MARK: - Add Extra spacing in tableView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        //MARK: - Add Items In tableView
        listItems = [
            HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "Featured near you", rowHeight: 240, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
            HomeBaseCell.HomeListItem(identifier: HomeCuisinesCell.nibName(), sectionName: "52 cuisines near you", rowHeight: 100, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
            HomeBaseCell.HomeListItem(identifier: HomeFoodItemCell.nibName(), sectionName: "", rowHeight: 240, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"]),
            HomeBaseCell.HomeListItem(identifier: HomePrayerSpacesCell.nibName(), sectionName: "12 prayer spaces near you", rowHeight: 240, data: ["name": "Shahzaib Qureshi", "desc" : "Welcome"])
        ]
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        else {
            // it will fix from properties of table view
        }
    }
    
    @IBAction func buttonSideMenu(_ sender: Any) {
        openMenu()
    }
    @IBAction func buttonSearchLocation(_ sender: Any) {
        navigateToEditAddressesViewController()
    }
    
    @IBAction func buttonNotification(_ sender: Any) {
    }
    @IBAction func buttonCart(_ sender: Any) {
    }
    
    func sideMenuSetup() {
        let myCustomView: SideMenuView = UIView.fromNib()

        
//        let headerView = UINib(nibName: "SideMenuView", bundle: Bundle(for: SideMenuView.self)).instantiate(withOwner: self, options: nil)[0] as! UIView
        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: myCustomView.frame.width - 80, height: UIScreen.main.bounds.height))
        menuView.addSubview(myCustomView)
        menuView.frame.size.width = myCustomView.frame.width - 80
        
        let menuConfig: MenuConfig = .init(vc: self, customView: menuView)
        sideMenu = .init(menuConfig)
        myCustomView.viewController = self
        myCustomView.buttonBackHandler = closeMenu
        myCustomView.closeMenuHandler = closeMenu
    }
    func openMenu() {
        sideMenu.openMenu()
    }
    func closeMenu() {
        sideMenu.closeMenu()
    }
    func closeMenu(indexPath: IndexPath) {
        closeMenu()
    }
    
    func toggleMenu() {
        sideMenu.toggleMenu()
    }
    
    func navigateToEditAddressesViewController() {
        let vc = UIStoryboard.init(name: StoryBoard.name.addresses.rawValue, bundle: nil).instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        vc.buttonContinueHandler = { location in
            print("button continue pressed \(location)")
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getuser() {       
        APIs.postAPI(apiName: .getuser, methodType: .get, encoding: URLEncoding.default) { responseData, success, errorMsg in
            print(responseData ?? "")
            print(success)
            let model: ModelGetUserResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelGetUserResponseLocal = model
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 20
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCell", for: indexPath) as! HomeMenuCell
        cell.labelName.text = arrayNames[indexPath.item]
        cell.imageViewTitle.image = UIImage(named: arrayNamesIcon[indexPath.item])
//        if indexPath.item == 0 {
//            cell.viewImageViewTitleBackGround.backgroundColor = .clrApp
//        }
//        else {
//            cell.viewImageViewTitleBackGround.backgroundColor = .clrUnselected
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleForHeader = (listItems[section]).sectionName
        if titleForHeader == "" {
            return 20
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRow = (listItems[indexPath.section]).rowHeight
        return CGFloat(heightForRow)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (listItems[indexPath.section]).identifier) as! HomeBaseCell
        print((listItems[indexPath.row]).identifier)
        print(indexPath.section)
        cell.setupWithType(type: listItems[indexPath.section])
        cell.viewController = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCell") as? HomeSectionHeaderCell {
            myHeader.section = section
            if let titleLabel = myHeader.labelTitle {
                titleLabel.text = (listItems[section]).sectionName
            }
            return myHeader
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    }
}
