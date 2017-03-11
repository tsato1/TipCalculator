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
        let allPercentages = SectionData(title: "Percentages", data: "10%", "12%", "13%", "15%", "17%", "18%", "20%", "22%", "23%", "25%")
        let allNumPeople = SectionData(title: "Number of People", data: "1", "2", "3", "4", "5", "6", "7", "8", "9")
        return [allPercentages, allNumPeople]
    }()
    var pickedPercentageIndeces = [3, 5, 6]
    var pickedNumPeopleIndeces = [0, 1, 2, 3, 4]
    
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
        let count = mySections[0].numberOfItems + mySections[1].numberOfItems
        for _ in 0..<count {
            let newModel = MyTalbeViewCellModel();
            newModel.turnedON = false
            feedModelArray.append(newModel)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let settings = UserDefaults.standard
        pickedPercentageIndeces = settings.array(forKey: "percentageIndeces") as! [Int]
        pickedNumPeopleIndeces = settings.array(forKey: "numPeopleIndeces") as! [Int]
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
        cell.textLabel?.text = cellTitle
        cell.registerSwitch.isOn = false
        
        if indexPath.section == 0 {
            if indexPath.row == pickedPercentageIndeces[0] ||
                indexPath.row == pickedPercentageIndeces[1] ||
                indexPath.row == pickedPercentageIndeces[2] {
                    cell.registerSwitch.isOn = true
            }
        } else {
            if indexPath.row == pickedNumPeopleIndeces[0] ||
                indexPath.row == pickedNumPeopleIndeces[1] ||
                indexPath.row == pickedNumPeopleIndeces[2] ||
                indexPath.row == pickedNumPeopleIndeces[3] ||
                indexPath.row == pickedNumPeopleIndeces[4] {
                    cell.registerSwitch.isOn = true
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

        let settings = UserDefaults.standard
        
        if cell.registerSwitch.isOn == false {
            if indexPath?.section == 0 {
                pickedPercentageIndeces.remove(at: 0)
                settings.set(pickedPercentageIndeces, forKey: "percentageIndeces")
            } else {
                pickedNumPeopleIndeces.remove(at: 0)
                settings.set(pickedNumPeopleIndeces, forKey: "numPeopleIndeces")
            }
        } else {
            if indexPath?.section == 0 {
                pickedPercentageIndeces.append((indexPath?.row)!)
                settings.set(pickedPercentageIndeces, forKey: "percentageIndeces")
            } else {
                pickedNumPeopleIndeces.append((indexPath?.row)!)
                settings.set(pickedNumPeopleIndeces, forKey: "numPeopleIndeces")
            }
        }
        settings.synchronize()
        
        print("indexPath.row=\(indexPath?.row)")
        for index in 0..<pickedNumPeopleIndeces.count {
            print("PickedNumPeopleIndeces["+String(index)+"="+"]" + String(pickedNumPeopleIndeces[index]))
        }
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
