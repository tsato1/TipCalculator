//
//  ViewController.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/4/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var Butotn: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentageToggle: UISegmentedControl!
    @IBOutlet weak var numPeopleToggle: UISegmentedControl!
    
    let limitLength = 10
    
    var pickedPercentages = [15, 18, 20]
    var pickedNumPeople = [1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        
        let settings = UserDefaults.standard
        settings.register(defaults: ["percentages": pickedPercentages])
        settings.register(defaults: ["numpeople": pickedNumPeople])

        /* uncomment and run when default value needs to be set */
        settings.set(pickedPercentages, forKey: "percentages")
        settings.set(pickedNumPeople, forKey: "numpeople")
        settings.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
        billField.placeholder = "$"
        
        let settings = UserDefaults.standard
        pickedPercentages = settings.array(forKey: "percentages") as! [Int]
        pickedNumPeople = settings.array(forKey: "numpeople") as! [Int]
        
        for i in 0..<pickedPercentages.count {
            percentageToggle.setTitle(String(pickedPercentages[i]) + "%", forSegmentAt: i)
        }
        for j in 0..<pickedNumPeople.count {
            numPeopleToggle.setTitle(String(pickedNumPeople[j]), forSegmentAt: j)
        }
        
        pickedPercentages.sort()
        pickedNumPeople.sort()
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        let billText = billField.text!
        let bill = Double(billText) ?? 0
        let tip = bill / 100 * Double(pickedPercentages[percentageToggle.selectedSegmentIndex])
        var total = bill + tip
        total = total / Double(pickedNumPeople[numPeopleToggle.selectedSegmentIndex])
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
}

