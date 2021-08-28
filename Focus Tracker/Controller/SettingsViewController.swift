//
//  SettingsViewController.swift
//  Focus Tracker
//
//  Created by Edgar Olvera on 8/18/21.
//
//  Second view controller which lets the user set preferences for the intervals
//  Including length of intervals and amount
//  A closure pass the data submitted back to the main view controller, which reassigns the values
//  to meet the preferences picked.

//  We use a UIPicker to handle user inputted, with seperate arrays to store the user's selection of choices.

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var WorkIntervalTextField: UITextField!
    @IBOutlet weak var BreakTextField: UITextField!
    @IBOutlet weak var LongBreakTextField: UITextField!
    @IBOutlet weak var LongBreakIntervalTextField: UITextField!
    @IBOutlet weak var IntervalGoalTextField: UITextField!
    
    let workIntervals = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    
    let shortBreakIntervals = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    let longBreakIntervals = ["5", "10", "15", "20", "25", "30"]
    
    let intervalsBeforeLongBreak = ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    let intervalGoals = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    
    var completionHandler: ((Int?, Int?, Int?, Int?, Int?, Bool?) -> Void)?
    
    var workInterval : Int?
    
    var breakInterval : Int?
    
    var longBreakInterval : Int?
    
    var intervalsBeforeLB : Int?
    
    var intervalGoal : Int?
    
    var workIntervalPicker = UIPickerView()
    var shortBreakIntervalPicker = UIPickerView()
    var longBreakIntervalsPicker = UIPickerView()
    var intervalsBeforeLongBreakPicker = UIPickerView()
    var intervalGoalsPicker = UIPickerView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workIntervalPicker.dataSource = self
        workIntervalPicker.delegate = self
        
        shortBreakIntervalPicker.dataSource = self
        shortBreakIntervalPicker.delegate = self
        
        longBreakIntervalsPicker.dataSource = self
        longBreakIntervalsPicker.delegate = self
        
        intervalsBeforeLongBreakPicker.dataSource = self
        intervalsBeforeLongBreakPicker.delegate = self
        
        intervalGoalsPicker.dataSource = self
        intervalGoalsPicker.delegate = self
        
        
        WorkIntervalTextField.inputView = workIntervalPicker
        WorkIntervalTextField.text = String(workInterval!)
        
        BreakTextField.inputView = shortBreakIntervalPicker
        BreakTextField.text = String(breakInterval!)
        
        LongBreakTextField.inputView = longBreakIntervalsPicker
        LongBreakTextField.text = String(longBreakInterval!)
        
        LongBreakIntervalTextField.inputView = intervalsBeforeLongBreakPicker
        LongBreakIntervalTextField.text = String(intervalsBeforeLB!)
        
        IntervalGoalTextField.inputView = intervalGoalsPicker
        IntervalGoalTextField.text = String(intervalGoal!)
        
        
        workIntervalPicker.tag = 0
        shortBreakIntervalPicker.tag = 1
        longBreakIntervalsPicker.tag = 2
        intervalsBeforeLongBreakPicker.tag = 3
        intervalGoalsPicker.tag = 4
        
        
        workIntervalPicker.selectRow(workIntervals.firstIndex(of: String(workInterval!))!, inComponent: 0, animated: false)
        shortBreakIntervalPicker.selectRow(shortBreakIntervals.firstIndex(of: String(breakInterval!))!, inComponent: 0, animated: false)
        longBreakIntervalsPicker.selectRow(longBreakIntervals.firstIndex(of: String(longBreakInterval!))!, inComponent: 0, animated: false)
        intervalsBeforeLongBreakPicker.selectRow(intervalsBeforeLongBreak.firstIndex(of: String(intervalsBeforeLB!))!, inComponent: 0, animated: false)
        intervalGoalsPicker.selectRow(intervalGoals.firstIndex(of: String(intervalGoal!))!, inComponent: 0, animated: false)
        
        
        setupToolbar()
        // Do any additional setup after loading the view.
    }
    
    func setupToolbar()
    {
        //Create a toolbar
        let bar = UIToolbar()
           
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
           
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
           
           //Add the toolbar to our textfield
        WorkIntervalTextField.inputAccessoryView = bar
        BreakTextField.inputAccessoryView = bar
        LongBreakTextField.inputAccessoryView = bar
        LongBreakIntervalTextField.inputAccessoryView = bar
        IntervalGoalTextField.inputAccessoryView = bar
       }
    
    @objc func dismissMyKeyboard(){
            view.endEditing(true)
        }
 
    @IBAction func submitValues(_ sender: UIButton) {
        
        var skip:Bool?
        
        let alert = UIAlertController(title: "Warning", message: "Changes will not be made until the next interval. Would you like to skip or continue this current interval?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Skip", comment: "Default action"), style: .default, handler: { _ in
            skip = true
            self.completionHandler?(self.workInterval, self.breakInterval, self.longBreakInterval, self.intervalsBeforeLB, self.intervalGoal, skip)
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: "Cancel action"), style: .cancel, handler: { _ in
            skip = false
            self.completionHandler?(self.workInterval, self.breakInterval, self.longBreakInterval, self.intervalsBeforeLB, self.intervalGoal, skip)
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return workIntervals.count
        case 1:
            return shortBreakIntervals.count
        case 2:
            return longBreakIntervals.count
        case 3:
            return intervalsBeforeLongBreak.count
        case 4:
            return intervalGoals.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return workIntervals[row]
        case 1:
            return shortBreakIntervals[row]
        case 2:
            return longBreakIntervals[row]
        case 3:
            return intervalsBeforeLongBreak[row]
        case 4:
            return intervalGoals[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            WorkIntervalTextField.text = workIntervals[row]
            workInterval = Int(workIntervals[row])
        case 1:
            BreakTextField.text = shortBreakIntervals[row]
            breakInterval = Int(shortBreakIntervals[row])
        case 2:
            LongBreakTextField.text = longBreakIntervals[row]
            longBreakInterval = Int(longBreakIntervals[row])
        case 3:
            LongBreakIntervalTextField.text = intervalsBeforeLongBreak[row]
            intervalsBeforeLB = Int(intervalsBeforeLongBreak[row])
        case 4:
            IntervalGoalTextField.text = intervalGoals[row]
            intervalGoal = Int(intervalGoals[row])
        default:
            break
        }
    }
    

}
