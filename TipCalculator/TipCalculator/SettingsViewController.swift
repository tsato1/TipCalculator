//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/4/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let allPercentages = ["10%", "12%", "13%", "15%", "17%", "18%", "20%", "22%", "23%", "25%"]
    let allNumPeople = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let pickedPercentageIndeces = [3, 5, 6]
    let pickedNumPeopleIndeces = [0, 1, 2, 3, 4]
    
    @IBOutlet weak var tableView: UITableView!
    
    var feedModelArray = [MyTalbeViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCustomCell")
        fillDataArray()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fillDataArray() {
        let count = allPercentages.count + allNumPeople.count
        for index in 0..<count {
            let newModel = MyTalbeViewCellModel();
            newModel.turnedON = false
            feedModelArray.append(newModel)
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return allPercentages.count
        } else {
            return allNumPeople.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell") as! MyTableViewCell
        cell.setupWithModel(model: feedModelArray[indexPath.row])
        cell.delegate = self
        
        if indexPath.section == 0 {
            let row = allPercentages[indexPath.row]
            cell.textLabel?.text = row
            if indexPath.row == pickedPercentageIndeces[0] ||
                indexPath.row == pickedPercentageIndeces[1] ||
                indexPath.row == pickedPercentageIndeces[2] {
                cell.registerSwitch.isOn = true
            } else {
                cell.registerSwitch.isOn = false
            }
        } else {
            let row = allNumPeople[indexPath.row]
            if indexPath.row == pickedNumPeopleIndeces[0] ||
                indexPath.row == pickedNumPeopleIndeces[1] ||
                indexPath.row == pickedNumPeopleIndeces[2] ||
                indexPath.row == pickedNumPeopleIndeces[3] ||
                indexPath.row == pickedNumPeopleIndeces[4] {
                cell.registerSwitch.isOn = true
            } else {
                cell.registerSwitch.isOn = false
            }
            cell.textLabel?.text = row
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Percentages"
        } else {
            return "Number of People"
        }
    }
}

extension SettingsViewController: MyTalbeViewCellDelegate {
    func didTappSwitch(cell: MyTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        feedModelArray[(indexPath?.row)!].turnedON = cell.registerSwitch.isOn
    }
}
