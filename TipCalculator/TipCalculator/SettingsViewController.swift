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
    
    var feedModelArray = [MyTalbeViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCustomCell")
        fillDataArray()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fillDataArray() {
        for index in 0..<50 {
            let newModel = MyTalbeViewCellModel();
            newModel.label = "aaa"
            newModel.turnedON = false
            feedModelArray.append(newModel)
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return percentages.count
//        } else {
//            return numPeople.count
//        }
        return 50
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell") as! MyTableViewCell
        cell.setupWithModel(model: feedModelArray[indexPath.row])
        cell.delegate = self
        
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

extension SettingsViewController: MyTalbeViewCellDelegate {
    func didTappSwitch(cell: MyTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        feedModelArray[(indexPath?.row)!].turnedON = cell.registerSwitch.isOn
    }
}
