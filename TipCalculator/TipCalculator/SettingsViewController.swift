//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/4/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let WARNING_PERCENTAGE_COUNT = "Please select\nTHREE\nPercentages"
    let WARNING_NUMPEOPLE_COUNT = "Please select\nFIVE\nNumber Of People"
    let PERCENTAGE_COUNT = 3
    let NUMPEOPLE_COUNT = 5
    var pickedPercentages = [15, 18, 20]
    var pickedNumPeople = [1, 2, 3, 4, 5]
    lazy var mySections: [SectionData] = {
        let allPercentages = SectionData(title: "Percentages", data: "10", "12", "13", "15", "17", "18", "20", "22", "23", "25")
        let allNumPeople = SectionData(title: "Number of People", data: "1", "2", "3", "4", "5", "6", "7", "8", "9")
        return [allPercentages, allNumPeople]
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var warningView: UIView!
    @IBOutlet weak var warningViewMessageLabel: UILabel!
    var cancelButton : UIBarButtonItem?
    var doneButton : UIBarButtonItem?
    var feedModelArray = [MyTalbeViewCellModel]()
    
    var effect: UIVisualEffect!
    
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
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        warningView.layer.cornerRadius = 5
        tableView.layer.zPosition = 1
        visualEffectView.layer.zPosition = 0
        warningView.layer.zPosition = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let settings = UserDefaults.standard
        pickedPercentages = settings.array(forKey: "percentages") as! [Int]
        pickedNumPeople = settings.array(forKey: "numpeople") as! [Int]
        
        print("viewWillAppear() percentages=\(pickedPercentages)")
    }

    
    func fillDataArray() {
        let count = mySections[0].numberOfItems + mySections[1].numberOfItems
        for _ in 0..<count {
            let newModel = MyTalbeViewCellModel();
            newModel.turnedON = false
            feedModelArray.append(newModel)
        }
    }
    
    func onCancelClick(sender: UIBarButtonItem!) {
        if !isValidCount(count: PERCENTAGE_COUNT, array: pickedPercentages) {
            warningViewMessageLabel.text = WARNING_PERCENTAGE_COUNT
            animateIn()
            return
        }
        if !isValidCount(count: NUMPEOPLE_COUNT, array: pickedNumPeople) {
            warningViewMessageLabel.text = WARNING_NUMPEOPLE_COUNT
            animateIn()
            return
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func onDoneClick(sender: UIBarButtonItem!) {
        if !isValidCount(count: PERCENTAGE_COUNT, array: pickedPercentages) {
            warningViewMessageLabel.text = WARNING_PERCENTAGE_COUNT
            animateIn()
            return
        }
        if !isValidCount(count: NUMPEOPLE_COUNT, array: pickedNumPeople) {
            warningViewMessageLabel.text = WARNING_NUMPEOPLE_COUNT
            animateIn()
            return
        }
        
        let settings = UserDefaults.standard
        settings.set(pickedPercentages, forKey: "percentages")
        settings.set(pickedNumPeople, forKey: "numpeople")
        settings.synchronize()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func isValidCount(count: Int, array: [Int]) -> Bool {
        if (count == array.count) {
            return true
        }
        
        return false
    }
    
    func animateIn() {
        self.view.addSubview(warningView)
        warningView.center = self.view.center
        warningView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        warningView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.warningView.alpha = 1
            self.warningView.transform = CGAffineTransform.identity
            self.tableView.layer.zPosition = 0
            self.visualEffectView.layer.zPosition = 1
            self.warningView.layer.zPosition = 2
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.warningView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.warningView.alpha = 0
            self.visualEffectView.effect = nil
            self.tableView.layer.zPosition = 1
            self.visualEffectView.layer.zPosition = 0
            self.warningView.layer.zPosition = 0
        }) {(Success: Bool) in
            self.warningView.removeFromSuperview()
        }
    }
    
    func warningViewOKButton(_ sender: AnyObject) {
        animateOut()
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
        cell.registerSwitch.isOn = false
        
        if indexPath.section == 0 {
            cell.textLabel?.text = String(cellTitle + "%")
            for index in 0..<pickedPercentages.count {
                if Int(cellTitle) == pickedPercentages[index] {
                    cell.registerSwitch.isOn = true
                }
            }
        } else {
            cell.textLabel?.text = String(cellTitle)
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
                for index in 0..<pickedPercentages.count {
                    if pickedPercentages[index] == (Int(cellTitle)!) {
                        pickedPercentages.remove(at: index)
                        break
                    }
                }
                settings.set(pickedPercentages, forKey: "percentages")
            } else {
                for index in 0..<pickedNumPeople.count {
                    if pickedNumPeople[index] == (Int(cellTitle)!) {
                        pickedNumPeople.remove(at: index)
                        break
                    }
                }
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
        
        
        pickedPercentages.sort()
        pickedNumPeople.sort()
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
