//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/4/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let percentages = ["10%", "12%", "13%", "15%", "17%", "18%", "20%", "22%", "23%", "25%"]
    let numPeople = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCustomCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UIViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return percentages.count
//        } else {
//            return numPeople.count
//        }
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell") as! MyTableViewCell
        
//        if indexPath.section == 0 {
//            let row = percentages[indexPath.row]
//            cell.textLabel?.text = row
//        } else {
//            let row = numPeople[indexPath.row]
//            cell.textLabel?.text = row
//        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Percentages"
//        } else {
//            return "Number of People"
//        }
        return "OK"
    }
}
