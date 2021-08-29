//
//  ViewController.swift
//  Focus Tracker
//
//  Created by Edgar Olvera on 8/4/21.
//
//  Summary:
//  This main view controller runs a simple pomodoro timer app.
//  A pomodoro timer is a productivity method where a user can schedule the amount time
//  to be productive and when to take breaks. The amount time is called an interval. The user gets
//  regular "short" break between their productive intervals and one "long" break after certain number
//  of productive intervals.

//  Features:
//  - lets the user know how much time they spent being productive for the day.
//  - is capable of functioning while phone is locked or switching out of the app.
//  - gives users the option to edit intervals in lenght and amount;
//  - saves data to be accessed when app shuts off.
//  - sends local notifications to let user know when an interval is done if the app is not open.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var intevalLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    
    var lastDateObserved = Date()
    
    var timer = Timer()
    
    var user = Interval()
    
    var center = UNUserNotificationCenter.current()
    
    let pauseSign = UIImage.init(systemName: "pause")
    let playSign = UIImage.init(systemName: "play")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  The timer "resets" itself every day, so we save the day # in our object
        //  when the app loads we check if the current day # is equal to the one saved.
        
        var reset = true
        
        let currentDate = Date()
        let calendar = Calendar.current
         
         //  if true we know the timer should not "reset" if false we "reset" the timer
         //  and save the current day #
        if let value = UDM.shared.defaults.value(forKey: "currentDay") as? Int {
            if value == calendar.component(.day, from: currentDate) {
                reset = false
            }
            else
            {
                setData(key: "currentDay", data: calendar.component(.day, from: currentDate))
            }
        }
        else
        {
            setData(key: "currentDay", data: calendar.component(.day, from: currentDate))
        }
     
        
        //  The user gets the option to customize certain features of the timer.
        //  When the app loads the user will see their preferences for the timer instead of default values.
        
        //  We must initialize the variables based on user data or the default value.
        //  If default, we save this value into the memory.
        
        if let value = UDM.shared.defaults.value(forKey: "workTime") as? Int {
            user.workTime = value
        }
        else{
            setData(key: "workTime", data: user.workTime)
        }
        
        if let value = UDM.shared.defaults.value(forKey: "breakTime") as? Int {
            user.breakTime = value
        }
        else{
            setData(key: "breakTime", data: user.breakTime)
        }
        
        if let value = UDM.shared.defaults.value(forKey: "longBreakTime") as? Int {
            user.longBreakTime = value
        }
        else{
            setData(key: "longBreakTime", data: user.longBreakTime)
        }
        
        if let value = UDM.shared.defaults.value(forKey: "intervalsBeforeLngBr") as? Int {
            user.intervalsBeforeLongBreak = value
            user.nextIntervalBeforeLongBreak = value
        }
        else{
            setData(key: "intervalsBeforeLngBr", data: user.intervalsBeforeLongBreak)
        }
        
        if let value = UDM.shared.defaults.value(forKey: "intervalGoal") as? Int {
            user.intervalGoal = value
        }
        else{
            setData(key: "intervalGoal", data: user.intervalGoal)
        }
        
        
        stateLabel.text = "Work"
        
        
        // If not reset, we continue to keep track of the current interval, hours, minutes, and the next interval til the long break
        //  else we "reset" and keep the default initialize values
        if !reset {
            if let value = UDM.shared.defaults.value(forKey: "currentMinutes") as? Int {
                user.currentMinutes = value
            }
            else{
                setData(key: "currentMinutes", data: user.currentMinutes)
            }
            
            if let value = UDM.shared.defaults.value(forKey: "currentSeconds") as? Int {
                user.currentSeconds = value
            }
            else{
                setData(key: "currentSeconds", data: user.currentSeconds)
            }
            
            if let value = UDM.shared.defaults.value(forKey: "currentInterval") as? Int {
                user.interval = value
            }
            else{
                setData(key: "currentInterval", data: user.interval)
            }
            
            if let value = UDM.shared.defaults.value(forKey: "totalHours") as? Int {
                user.totalHours = value
            }
            else{
                setData(key: "totalHours", data: user.totalHours)
            }
            
            if let value = UDM.shared.defaults.value(forKey: "totalMinutes") as? Int {
                user.totalMinutes = value
            }
            else{
                setData(key: "totalMinutes", data: user.totalMinutes)
            }
            
            
            if let value = UDM.shared.defaults.value(forKey: "nextIntervalForLngBr") as? Int {
                user.setNextIntervalBeforeLongBreak(_: value)
            }
            else{
                setData(key: "nextIntervalForLngBr", data: user.nextIntervalBeforeLongBreak)
            }
            
            
            //  We also keep track at what phase the user was on before close.
            
            if let value = UDM.shared.defaults.value(forKey: "onBreak") as? Int {
                if value == 0 {
                    user.onBreak = false
                }
                else{
                    user.onBreak = true
                }
            }
            else{
                setData(key: "onBreak", data: 0)
            }
            
            if let value = UDM.shared.defaults.value(forKey: "onWork") as? Int {
                if value == 0 {
                    user.onWork = false
                }
                else{
                    user.onWork = true
                }
            }
            else{
                setData(key: "onWork", data: 1)
            }
            
            if let value = UDM.shared.defaults.value(forKey: "currentLabel") as? Int {
                switch value {
                case 0:
                    stateLabel.text = "Work"
                case 1:
                    stateLabel.text = "Break"
                case 2:
                    stateLabel.text = "Long Break"
                default:
                    break
                }
            }
            else{
                setData(key: "currentLabel", data: 0)
            }
        }   // end reset
        else
        {
            //  Save default initialized values in case app shuts down before timer starts
            setData(key: "currentMinutes", data: user.currentMinutes)
            setData(key: "currentSeconds", data: user.currentSeconds)
            setData(key: "currentInterval", data: user.interval)
            setData(key: "totalHours", data: user.totalHours)
            setData(key: "totalMinutes", data: user.totalMinutes)
            setData(key: "nextIntervalForLngBr", data: user.nextIntervalBeforeLongBreak)
            
            setData(key: "onBreak", data: 0)
            setData(key: "onWork", data: 1)
            setData(key: "currentLabel", data: 0)
        }
        
        // Change UI to reflect current phase and time
        
        if user.onWork {
            timerLabel.textColor = UIColor.systemRed
            
            if reset || user.currentSeconds == 60 {
                timerLabel.text = formatTimerText(time: user.workTime)
                user.currentMinutes = user.workTime - 1
            }
            else{
                let minute_text = user.currentMinutes < 10 ? "0\(user.currentMinutes)" : String(user.currentMinutes);
                let seconds_text = user.currentSeconds < 10 ? "0\(user.currentSeconds)" : "\(user.currentSeconds)";
                
                timerLabel.text = "\(minute_text):\(seconds_text)"
            }
        
            playButton.tintColor = UIColor.systemRed
            
        }
        
        if user.onBreak {
            timerLabel.textColor = UIColor.systemGreen
            if reset || user.currentSeconds == 60 {
                timerLabel.text = formatTimerText(time: user.breakTime)
                user.currentMinutes = user.breakTime - 1
            }
            else{
                let minute_text = user.currentMinutes < 10 ? "0\(user.currentMinutes)" : String(user.currentMinutes);
                let seconds_text = user.currentSeconds < 10 ? "0\(user.currentSeconds)" : String(user.currentSeconds);
                
                timerLabel.text = "\(minute_text):\(seconds_text)"
            }
            
            playButton.tintColor = UIColor.systemGreen
        }
        
        intevalLabel.text = "\(user.interval)/\(user.intervalGoal)"
        hourLabel.text = "\(user.totalHours)h"
        minutesLabel.text = "\(user.totalMinutes)m"
        
        playButton.setBackgroundImage(playSign, for: .normal)
        playButton.tag = 0
        
        user.beenPressed = true
        
        center.requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) in
            // Check the error parameter and handle any errors
            if error != nil {
                print("error")
            }
        })
    }
    
    //  When user pressed "skip" button we must trigger an alert verifying if they are sure of their choice.
    //  If "yes" we call function to stop timer. If "no" we simply close the alert.
    @IBAction func skipButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to skip this interval?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            self.center.removeAllPendingNotificationRequests()
            self.closeTimer(skipped: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Cancel action"), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //  This method handles the center button press which either pauses and runs our timer.
    
    @IBAction func playButtonAction(_ sender: UIButton) {
       
        //  button tag indicates if the timer has been set on or off.
        //  If button is pressed and the timer has been set, then we know the user wants to temporarily pause the timer
        //  If the timer has not been set, then we preform the operation to start a new timer
        
        if (sender.tag != 0) {
            timer.invalidate()
            center.removeAllPendingNotificationRequests()
            
            user.currentSeconds = user.prevSeconds
            
            //      Reveals the play button, removes the pause button
            playButton.setBackgroundImage(playSign, for: .normal)
            playButton.tag = 0
            
            if user.onWork {
                playButton.tintColor = UIColor.systemRed
            }
            
            if user.onBreak {
                playButton.tintColor = UIColor.systemGreen
            }
            
            user.beenPressed = true
        }
        else {
            
            sender.tag = 1
            
            //      Reveals the pause button, removes the play button
            playButton.setBackgroundImage(pauseSign, for: .normal)
            
            if user.onWork {
                self.playButton.tintColor = UIColor.systemRed
            }
            
            if user.onBreak {
                self.playButton.tintColor = UIColor.systemGreen
            }
            
           
            if user.beenPressed {
                lastDateObserved = Date()
                user.beenPressed = false
            }
            
            callTimer()
        }
    }
    
    // This method will initialize the timer which repeats for every one interval second until manually stopped.
    // The method call on another function which will shedule a notification when timer is finished.
    func callTimer() {
        createNotification()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats:true)
    }
    
    //  After each interval a local notification is sent out to let the user know that the timer has ended.
    //  And to be aware of the next interval.
    
    //  The purpose for a notification is so the user does not need to be constantly checking their phone.
    //  When the timer ends the phone should either make a sound or vibrate (if on silent mode) can display
    //  the notification.
    func createNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = user.onWork ? "Productive interval has ended" : "Break time has ended"
        content.body = user.onBreak  ? "Time to be productive." : (user.interval + 1) == (user.nextIntervalBeforeLongBreak) ? "Time to take a long break": "Time to take a break"
        
        content.sound = UNNotificationSound.default
        
        //  This the notification is scheduled to send after the remaining amount of seconds and minutes
        //  currently on the timer.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double((user.currentMinutes * 60) + user.currentSeconds), repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request){(error) in
            // Check the error parameter and handle any errors
            if error != nil {
                print("error")
            }
        }
    }
    
    //  This method runs the timer.
    //  The timer updates based on the amount of time the program continues to run.
    //  For instance is the app has been on for 10 minutes we must keep track of that time and update the timer
    //  to reflect it.
    
    //  We get amount of time by first initializing the time the timer starts (from the playBuntton function),
    //  and add each second the program remains on.
    
    //  The purpose is so the program creates the illusion of being on in the background. That even if the user
    //  locks their phone or switches apps, their timer is still running.
    
    //  In reality the program terminates when the user locks the phone or switches apps.
    //  When the user returns, the program compares the time spent before and after termination and predicts
    //  the time to set.
    
    //  I have found the time to be absolute enough to create the illusion of being exact.
    @objc func updateTimer() {
        
        //  First find the accumulated time of last loop and current
        let accumulatedTime = Int(Date().timeIntervalSince(lastDateObserved))
        
        //  We subtract the gap to a static seconds value. The seconds is based on the last amount of seconds
        //  saved before program paused, closed, or started
        //  As an example if the timer starts from the beginning at 60 seconds
        //  The loop will run as: 60 - 1 = 59, 60 - 2 = 58, 60 - 3 = 57, ...
        user.prevSeconds = user.currentSeconds - accumulatedTime
    
        //  When the gap between termination and starting back is too large, the value becomes negative
        //  We must create a loop to restore the amount of seconds back to positive and to also
        //  add the excess seconds to our minutes value.
        if user.prevSeconds  < 0 {
            while (user.prevSeconds < 0)
            {
                user.prevSeconds  = 60 + user.prevSeconds
                user.decrementMinutes()
            }
            
            //  Reassign the date so accumulated time starts back to zero.
            lastDateObserved = Date()
            user.currentSeconds = user.prevSeconds - 1
        }
        
              
        //  If minutes value is below zero, we know the timer is done and should call the function to stop timer
        if user.currentMinutes < 0 {
            closeTimer(skipped: false)
        }
        else
        {
            //  Format the timer label
            
            let minute_text = user.currentMinutes < 10 ? "0\(user.currentMinutes)" : String(user.currentMinutes);
            let seconds_text = user.prevSeconds < 10 ? "0\(user.prevSeconds)" : String(user.prevSeconds);
        
            timerLabel.text = "\(minute_text):\(seconds_text)"
        
            //  seconds = 0 means a minutes has, so we update minute value and set seconds back to 59.
            //  We also reassign date so accumulated time is zero.
            if user.prevSeconds == 0 {
                user.decrementMinutes()
                user.currentSeconds = 59
                lastDateObserved = Date()
            }
    
            //  Save current minutes and seconds to the main memory. In case the app shuts down completely,
            //  the saved data will recollect the last minutes and seconds on the timer.
            setData(key: "currentMinutes", data: user.currentMinutes)
            setData(key: "currentSeconds", data: user.prevSeconds)
        }
    }
    
    
    //  This method stops the timer and prepares for the next phase/interval.
    //  Our close timer function contains a parameter to check if the timer ran to completion or stopped
    //  abruptly by the user.
    //  If the timer ran to completion the program keeps track of the interval and time spent.
    //  Else we just move to preparing the next phase.
    func closeTimer(skipped : Bool) {
        timer.invalidate()
        
        playButton.tag = 0
        
        user.beenPressed = true
        
        //  If current phase was a work interval the next should be a break.
        //  Else the next phase will be a work interval
        if user.onWork
        {
            user.onWork = false
            user.onBreak = true
            
            //  In case the app shuts down, the program will know at what phase
            //  the user was on before shutting
            setData(key: "onWork", data: 0)
            setData(key: "onBreak", data: 1)
            
            if !skipped {
                user.incrementInterval()
                
                user.incrementTotalMinutes()
                
                while user.totalMinutes >= 60
                {
                    user.decrementTotalMinutes()
                    user.incrementTotalHours()
                }
                
                //  Here we send an alert congratulating the user if they reached their goal # of intervals.
                if (user.interval == user.intervalGoal) {
                    
                    let alert = UIAlertController(title: "Goal Finished!", message: "You have reached your goal and acheieved \(user.totalHours) hours and \(user.totalMinutes) minutes of productivity for today!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                setData(key: "totalMinutes", data: user.totalMinutes)
                setData(key: "totalHours", data: user.totalHours)
                setData(key: "currentInterval", data: user.interval)
            }
                
            
            //  We check if the next break is short or long, based on the value on intervals before
            //  long break and compare to the last interval spent
            if user.nextIntervalBeforeLongBreak == user.interval
            {
                stateLabel.text = "Long Break"
                timerLabel.text = formatTimerText(time: user.longBreakTime)
                
                user.currentMinutes = user.longBreakTime - 1
                
                user.incrementNextIntervalBeforeLongBreak()
                
                setData(key: "nextIntervalForLngBr", data: user.nextIntervalBeforeLongBreak)
                setData(key: "currentLabel", data: 2)
            }
            else
            {
                stateLabel.text = "Break"
                timerLabel.text = formatTimerText(time: user.breakTime)
                
                user.currentMinutes = user.breakTime - 1
                
                setData(key: "currentLabel", data: 1)
            }
            
            //  Initialize and format time, button, labels for next phase
            
            user.currentSeconds = 60
            
            timerLabel.textColor = UIColor.systemGreen
            
            playButton.tintColor = UIColor.systemGreen
            
            hourLabel.text = "\(user.totalHours)h"
            minutesLabel.text = "\(user.totalMinutes)m"
            
            intevalLabel.text = "\(user.interval)/\(user.intervalGoal)"
            
            setData(key: "currentMinutes", data: user.currentMinutes)
            setData(key: "currentSeconds", data: user.currentSeconds)
        }
        else
        {
            //  Does the same thing as lines above, except for Work instead of Break intervals
            user.onWork = true
            user.onBreak = false
            
            setData(key: "onWork", data: 1)
            setData(key: "onBreak", data: 0)
            
            stateLabel.text = "Work"
            timerLabel.textColor = UIColor.systemRed
            
            
            playButton.tintColor = UIColor.systemRed
            
            
            timerLabel.text = formatTimerText(time: user.workTime)
            
            user.currentMinutes = user.workTime - 1
            user.currentSeconds = 60
            
            setData(key: "currentMinutes", data: user.currentMinutes)
            setData(key: "currentSeconds", data: user.currentSeconds)
            setData(key: "currentLabel", data: 0)
        }
        
        playButton.setBackgroundImage(playSign, for: .normal)
    }
    
    
    //  Function gets called when user moves to the next view controller in charge of setting preferences
    //  The function uses a closure to pass data from the second view controller to the main one.
    
    //  When closure is called the program must assign all the variables to the new data the user has
    //  confirmed in the second view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? SettingsViewController {
            view.workInterval = user.workTime
            view.breakInterval = user.breakTime
            view.longBreakInterval = user.longBreakTime
            view.intervalsBeforeLB = user.intervalsBeforeLongBreak
            view.intervalGoal = user.intervalGoal
            
            view.completionHandler = {(work_time, break_time, long_break_time, long_break_interval, interval_goal, skip ) in
                self.user.workTime = work_time!
                self.user.breakTime = break_time!
                self.user.longBreakTime = long_break_time!
                self.user.intervalGoal = interval_goal!
                
                self.setData(key: "workTime", data: work_time!)
                self.setData(key: "breakTime", data: break_time!)
                self.setData(key: "longBreakTime", data: long_break_time!)
                self.setData(key: "intervalGoal", data: interval_goal!)
                
                //  We must be careful with reassigning the # of intervals before long break.
                //  The program must be able to compare value with the current interval to know
                //  how to assign the next interval before long break.
                
                //  For instance if the user wants a shorter number of intervals, say 3, and the current
                //  # of intervals the user has ran is 7. We must initialize the next interval before long break
                //  as 9 instead of 3; because 3 + 3 + 3 = 9.
                if self.user.intervalsBeforeLongBreak != long_break_interval!
                {
                    self.user.intervalsBeforeLongBreak = long_break_interval!
                    self.setData(key: "intervalsBeforeLngBr", data: long_break_interval!)
                    
                    self.user.setNextIntervalBeforeLongBreak(long_break_interval!)
                    
                    self.setData(key: "nextIntervalForLngBr", data: self.user.nextIntervalBeforeLongBreak)
                }
                
                //  Changes aren't shown until the next interval so we give the option in
                //  the second view controller of skipping the current interval.
                if skip!{
                    self.closeTimer(skipped: true)
                }
                
                self.intevalLabel.text = "\(self.user.interval)/\(interval_goal!)"
            }
        }
    }
    
    
    func formatTimerText(time:Int) -> String {
        if time < 0 {
            return "0\(time):00"
        }
        else{
            return "\(time):00"
        }
    }
    
    func setData(key: String, data: Int)
    {
        UDM.shared.defaults.setValue(data, forKey: key)
    }
    
}

//  Data is saved to memory with UserDefaults. The UserDefaults program is initialized as a seperate class
//  with a dedicated "suite" where the data is stored.
class UDM {
    static let shared = UDM()
    
    let defaults = UserDefaults(suiteName: "com.user.saved.data")!
}

