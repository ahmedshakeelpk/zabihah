//
//  AddressesViewController.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 07/07/2024.
//

import UIKit

class AddressesViewController: UIViewController {

    @IBOutlet weak var buttonAddNewAddress: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    
    var arrayTitle = ["Mango", "Ferrerri", "Toyota", "Honda", "Cycle", "iPhone", "Android", "Serina"]
    var arrayAddress = ["A quick brown", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog", "A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog A quick brown fox jumps over the lazy dog"]
    override func viewDidLoad() {
        super.viewDidLoad()
        AddressesCell.register(tableView: tableView)
        viewTitle.radius(radius: 12)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func buttonAddNewAddress(_ sender: Any) {
    }
    
}

extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell") as! AddressesCell
        cell.labelTitle.text = arrayTitle[indexPath.row]
        cell.labelAddress.text = arrayAddress[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    }
}
