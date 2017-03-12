//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/4/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    lazy var mySections: [SectionData] = {
        let allPercentages = SectionData(title: "Percentages", data: "10", "12", "13", "15", "17", "18", "20", "22", "23", "25")
        let allNumPeople = SectionData(title: "Number of People", data: "1", "2", "3", "4", "5", "6", "7", "8", "9")
        return [allPercentages, allNumPeople]
    }()
    var pickedPercentages = [15, 18, 20]
    var pickedNumPeople = [1, 2, 3, 4, 5]
    
    @IBOutlet weak var tableView: UITableView!
    
    var cancelButton : UIBarButtonItem?
    var doneButton : UIBarButtonItem?
    
    var feedModelArray = [MyTalbeViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCustomCell")
        fillDataArray()
        tableView.delegate = self
        tableView.dataSource = self
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onCancelClick(sender:)))
        doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(onDoneClick(sender:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    func fillDataArray() {
        let count = mySections[0].numberOfItems + mySections[1].numberOfItems
        for _ in 0..<count {
            let newModel = MyTalbeViewCellModel();
            newModel.turnedON = false
            feedModelArray.append(newModel)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let settings = UserDefaults.standard
        pickedPercentages = settings.array(forKey: "percentages") as! [Int]
        pickedNumPeople = settings.array(forKey: "numpeople") as! [Int]
    }
    
    func onCancelClick(sender: UIBarButtonItem!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func onDoneClick(sender: UIBarButtonItem!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySections[section].numberOfItems
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell") as! MyTableViewCell
        cell.setupWithModel(model: feedModelArray[indexPath.row])
        cell.delegate = self
        
        let cellTitle = mySections[indexPath.section][indexPath.row]
        cell.textLabel?.text = String(cellTitle + "%")
        cell.registerSwitch.isOn = false
        
        if indexPath.section == 0 {
            for index in 0..<pickedPercentages.count {
                if Int(cellTitle) == pickedPercentages[index] {
                    cell.registerSwitch.isOn = true
                }
            }
        } else {
            for index in 0..<pickedNumPeople.count {
                if Int(cellTitle) == pickedNumPeople[index] {
                    cell.registerSwitch.isOn = true
                }
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section].title
    }
}

extension SettingsViewController: MyTalbeViewCellDelegate {
    func didTappSwitch(cell: MyTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        feedModelArray[(indexPath?.row)!].turnedON = cell.registerSwitch.isOn
        let cellTitle = mySections[(indexPath?.section)!][(indexPath?.row)!]
        
        let settings = UserDefaults.standard
        
        if cell.registerSwitch.isOn == false {
            if indexPath?.section == 0 {
                pickedPercentages.remove(at: 0)
                settings.set(pickedPercentages, forKey: "percentages")
            } else {
                pickedNumPeople.remove(at: 0)
                settings.set(pickedNumPeople, forKey: "numpeople")
            }
        } else {
            if indexPath?.section == 0 {
                pickedPercentages.append(Int(cellTitle)!)
                settings.set(pickedPercentages, forKey: "percentages")
            } else {
                pickedNumPeople.append(Int(cellTitle)!)
                settings.set(pickedNumPeople, forKey: "numpeople")
            }
        }
        settings.synchronize()
        
        print("\(pickedPercentages)")
        print("\(pickedNumPeople)")
    }
}

struct SectionData {
    let title: String
    let data: [String]
    
    var numberOfItems: Int {
        return data.count
    }
    
    subscript(index: Int) -> String {
        return data[index]
    }
}

extension SectionData {
    init (title: String, data: String...) {
        self.title = title
        self.data = data
    }
}
