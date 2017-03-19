//
//  ViewController.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/4/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentageToggle: UISegmentedControl!
    @IBOutlet weak var numPeopleToggle: UISegmentedControl!
    
    let percentagesKey = "percentages"
    let numPeopleKey = "numpeople"
    let billAmountKey = "billamount"
    let limitLength = 7
    let formatter = NumberFormatter();
    
    var pickedPercentages = [15, 18, 20]
    var pickedNumPeople = [1, 2, 3, 4, 5]
    var billAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController.swift: viewDidLoad() called")
        billField.delegate = self
        
        let settings = UserDefaults.standard
        settings.register(defaults: [percentagesKey: pickedPercentages])
        settings.register(defaults: [numPeopleKey: pickedNumPeople])
        settings.register(defaults: [billAmountKey: billAmount])
        /* uncomment and run when default value needs to be set */
//        settings.set(pickedPercentages, forKey: percentagesKey)
//        settings.set(pickedNumPeople, forKey: numPeopleKey)
//        settings.set(billAmount, forKey: billAmountKey)
//        settings.synchronize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("ViewController.swift: did enter foreground")
        
        /*** timer for billfield ***/
//        let settings = UserDefaults.standard
//        stopTime = settings.object(forKey: stopTimeKey) as? Date
//        if let time = stopTime {
//            if time > Date() {
//                billAmount = settings.integer(forKey: billAmountKey)
//            } else {
//                billAmount = 0
//            }
//        }
//        stopTimer()
//        billField.text = String(billAmount)
        
        calculate()
    }
    
    func applicationDidEnterBackground(_ aplication: UIApplication) {
        print("ViewController.swift: did enter background")
        
        /*** timer for billfield ***/
//        UserDefaults.standard.set(billAmount, forKey: billAmountKey)
//        let time = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
//        startTimer(time!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController: viewWillAppear() called")
        
        billField.placeholder = String(formatter.currencySymbol)
        billField.becomeFirstResponder()
        billField.layer.cornerRadius = 8
        billField.keyboardType = UIKeyboardType.decimalPad
        
        let settings = UserDefaults.standard
        pickedPercentages = settings.array(forKey: percentagesKey) as! [Int]
        pickedNumPeople = settings.array(forKey: numPeopleKey) as! [Int]
        
        for i in 0..<pickedPercentages.count {
            percentageToggle.setTitle(String(pickedPercentages[i]) + "%", forSegmentAt: i)
        }
        for j in 0..<pickedNumPeople.count {
            numPeopleToggle.setTitle(String(pickedNumPeople[j]), forSegmentAt: j)
        }
        pickedPercentages.sort()
        pickedNumPeople.sort()
        
        calculate()
    }

    @IBAction func onTap(_ sender: AnyObject) {
        ///view.endEditing(true) // uncommenting gets keyboard to hide upon tapping somewhere in the view
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        calculate()
    }
    
    func calculate() {
        let billText = billField.text!
        let bill = Double(billText) ?? 0
        let tip = bill / 100 * Double(pickedPercentages[percentageToggle.selectedSegmentIndex])
        var total = bill + tip
        total = total / Double(pickedNumPeople[numPeopleToggle.selectedSegmentIndex])
        
        let formattedTip = formatter.string(for: tip)
        let formattedTotal = formatter.string(for: total)
        
        tipLabel.text = formattedTip
        totalLabel.text = formattedTotal
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    /***** about timer *****/
    let stopTimeKey = "stoptime"
    
    var stopTime: Date?
    var timer: Timer?
    
    func startTimer(_ stopTime: Date) {
        print("ViewController.swift: startTimer() called")
        UserDefaults.standard.set(stopTime, forKey: stopTimeKey)
        self.stopTime = stopTime
        print("current time: \(Date()), stopTime: \(stopTime)")
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        print("ViewController.swift: stopTimer() called")
        timer?.invalidate()
        timer = nil
    }
    
    func handleTimer(_ timer: Timer) {
        let now = Date()
        
        if stopTime! < now {
            /// do nothing
        } else {
            stopTimer()
        }
    }
}

