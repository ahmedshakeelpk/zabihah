//
//  DeliveryBottomSheet.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 17/08/2024.
//

import UIKit

class DeliveryBottomSheet: UIViewController {

    @IBOutlet weak var viewDummyButton: UIView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDismiss: UIButton!
    
    var isAmenities: Bool! = false
    var amenitiesData: [HomeViewController.Amenity?]? {
        didSet {
            
        }
    }
    
    var timingOpenClose: [HomeViewController.Timing?]?
    
    
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDummyButton.circle()
        if isAmenities {
            labelTitle.text = "Amenities"
        }
        else {
            labelTitle.text = "Hours Of operation"
        }
        DeliveryAmenitiesCell.register(tableView: tableView)
        DeliveryTimingCell.register(tableView: tableView)
    }
    
    @IBAction func buttonContinue(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension DeliveryBottomSheet: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAmenities {
            return amenitiesData?.count ?? 0
        }
        else {
            return timingOpenClose?.count ?? 0
        }
    }
    
    func getAmenityType(name: String) -> String {
        if "prayerspace".lowercased() == name.lowercased() {
            return "Prayer space available"
        }
        else if "restroom".lowercased() == name.lowercased() {
            return "Restroom available"
        }
        else if "parkingspace".lowercased() == name.lowercased() {
            return "Parking space available"
        }
        else if "togo".lowercased() == name.lowercased() {
            return "Takeout available"
        }
        else {
            return name
        }
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAmenities {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAmenitiesCell") as! DeliveryAmenitiesCell
            cell.labelTitle.text = getAmenityType(name: amenitiesData?[indexPath.row]?.type ?? "")
            
            
            cell.imageViewIcon.setImage(urlString: amenitiesData?[indexPath.row]?.iconImageWebUrl ?? "", placeHolderIcon: "amenitiesPlaceHolder")
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTimingCell") as! DeliveryTimingCell
            cell.labelDay.text = timingOpenClose?[indexPath.row]?.dayOfWeek
            cell.labelTiming.text = is12HourFormat ? "\("\((timingOpenClose?[indexPath.row]?.openingTime ?? "").time12String)") to \("\("\((timingOpenClose?[indexPath.row]?.closingTime ?? "").time12String)")")"
            :
            "\("\((timingOpenClose?[indexPath.row]?.openingTime ?? "").time24String)") to \("\("\((timingOpenClose?[indexPath.row]?.closingTime ?? "").time24String)")")"

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
       
    }
}

extension UIViewController {
    var is12HourFormat: Bool {
        let locale = NSLocale.current
            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
            if formatter.contains("a") {
                //phone is set to 12 hours
                return true
            } else {
                //phone is set to 24 hours
                return false
            }
    }
}

extension String {
    // Converts 24-hour format to 12-hour format
    // Input: 22:15
    // Output: 10:15 PM
    var time12String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: self) else {
            return "Invalid Time String"
        }
        dateFormatter.dateFormat = "hh:mm a"
        let formattedDate = dateFormatter.string(from: date)
        let lowercaseFormattedDate = formattedDate.lowercased()

        return lowercaseFormattedDate
    }
    
    // Converts 12-hour format to 24-hour format
    // Input: 10:15 PM
    // Output: 22:15
    var time24String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: self) else {
            return "Invalid Time String"
        }
        dateFormatter.dateFormat = "hh:mm a"
        let formattedDate = dateFormatter.string(from: date)
        let lowercaseFormattedDate = formattedDate.lowercased()

        return lowercaseFormattedDate
    }
}
