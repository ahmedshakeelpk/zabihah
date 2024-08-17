//
//  DeliveryBottomSheet.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 17/08/2024.
//

import UIKit

class DeliveryBottomSheet: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var isAmenities: Bool! = false
    var amenitiesData: [DeliveryDetailsViewController3.Amenities]? {
        didSet {
            
        }
    }
    
    var timingOpenClose: [DeliveryDetailsViewController3.Timing]?
    
    
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAmenities {
            labelTitle.text = "Amenities"
        }
        else {
            labelTitle.text = "Hours Of Operation"
        }
        DeliveryAmenitiesCell.register(tableView: tableView)
        DeliveryTimingCell.register(tableView: tableView)
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAmenities {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAmenitiesCell") as! DeliveryAmenitiesCell
            cell.labelTitle.text = amenitiesData?[indexPath.row].title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTimingCell") as! DeliveryTimingCell
            cell.labelDay.text = timingOpenClose?[indexPath.row].day
            cell.labelTiming.text = "\(timingOpenClose?[indexPath.row].openTime ?? "") \(timingOpenClose?[indexPath.row].closeTime ?? "")"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
       
    }
}
