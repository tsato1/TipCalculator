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
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentageToggle: UISegmentedControl!
    let limitLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        billField.becomeFirstResponder()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            let defaults = UserDefaults.standard
            let stringValue = defaults.object(forKey: "some_key_that_you_choose") as! String
            let intValue = defaults.integer(forKey: "another_key_that_you_choose")
            print("HELLO " + stringValue + " " + String(intValue))
        }
        else {
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        let percentages = [0.15, 0.18, 0.20]
        let billText = billField.text!
        let bill = Double(billText) ?? 0
        let tip = bill * percentages[percentageToggle.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
}

