//
//  Interval.swift
//  Focus Tracker
//
//  Created by Edgar Olvera on 8/26/21.
//

import Foundation

struct Interval {
    //  Variables which handle phases of app:
    //  whether the current interval is on work or break,
    //  And if the timer has been paused
    private var _onBreak : Bool
    private var _onWork : Bool
    private var _beenPressed : Bool
    
    
    //  Variables which handle time interval lengths
    private var _workTime : Int
    private var _breakTime : Int
    private var _longBreakTime : Int
    
    //  Variables which handle interval #s.
    private var _interval : Int
    private var _intervalGoal : Int
    private var _intervalsBeforeLongBreak : Int
    private var _nextIntervalBeforeLongBreak : Int
    
    //  Variables store the total time on work
    private var _totalHours : Int
    private var _totalMinutes : Int
    
    //  Variables handle the temp values of time to display and run on timer
    private var _prevSeconds : Int
    private var _currentMinutes : Int
    private var _currentSeconds : Int
    
    //  Initialize with default values
    init(){
        _onBreak = false
        _onWork = true
        _beenPressed = false
        
        _workTime = 25
        _breakTime = 5
        _longBreakTime = 15
        
        _interval = 0
        _intervalGoal = 10
        _intervalsBeforeLongBreak = 4
        _nextIntervalBeforeLongBreak = 4
        
        _totalHours = 0
        _totalMinutes = 0
        
        _prevSeconds = 0
        _currentMinutes = 24
        _currentSeconds = 60
    }
  
    //  Getter and setter for each variable
    
    var onBreak: Bool {
        get {
            return _onBreak
        }
        set {
            _onBreak = newValue
        }
    }
    
    var onWork: Bool {
        get {
            return _onWork
        }
        set {
            _onWork = newValue
        }
    }
    
    var beenPressed: Bool {
        get {
            return _beenPressed
        }
        set {
            _beenPressed = newValue
        }
    }
    
    var workTime: Int {
        get {
            return _workTime
        }
        set {
            _workTime = newValue
        }
    }
    
    var breakTime: Int {
        get {
            return _breakTime
        }
        set {
            _breakTime = newValue
        }
    }
    
    var longBreakTime: Int {
        get {
            return _longBreakTime
        }
        set {
            _longBreakTime = newValue
        }
    }
    
    var interval: Int {
        get {
            return _interval
        }
        set {
            _interval = newValue
        }
    }
    
    var intervalGoal: Int {
        get {
            return _intervalGoal
        }
        set {
            _intervalGoal = newValue
        }
    }
    
    var intervalsBeforeLongBreak : Int{
        get{
            return _intervalsBeforeLongBreak
        }
        set{
            _intervalsBeforeLongBreak = newValue
        }
    }
    
    var nextIntervalBeforeLongBreak: Int {
        get {
            return _nextIntervalBeforeLongBreak
        }
        set {
            _nextIntervalBeforeLongBreak = newValue
        }
    }
    
    var totalHours : Int {
        get {
            return _totalHours
        }
        set {
            _totalHours = newValue
        }
    }
    
    var totalMinutes: Int {
        get {
            return _totalMinutes
        }
        set {
            _totalMinutes = newValue
        }
    }
    
    var prevSeconds: Int {
        get {
            return _prevSeconds
        }
        set {
            _prevSeconds = newValue
        }
    }
    
    var currentMinutes: Int {
        get {
            return _currentMinutes
        }
        set {
            _currentMinutes = newValue
        }
    }

    var currentSeconds: Int {
        get {
            return _currentSeconds
        }
        set {
            _currentSeconds = newValue
        }
    }
    
    //  Mutating functions for certain variables. This way user does not need to preform a new setter
    //  assigment to change a value. They simply call one of these functions to preform the change/reassignment.
    
    mutating func incrementInterval() {
        self._interval += 1
    }
    
    mutating func incrementTotalHours(){
        self._totalHours += 1
    }
    
    mutating func incrementTotalMinutes(){
        self._totalMinutes += self._workTime
    }
    mutating func decrementTotalMinutes(){
        self._totalMinutes -= 60
    }
    
    mutating func decrementMinutes(){
        self._currentMinutes -= 1
    }
    
    mutating func decrementSeconds(){
        self._currentSeconds -= 1
    }
    
    mutating func incrementNextIntervalBeforeLongBreak(){
        self._nextIntervalBeforeLongBreak += self._intervalsBeforeLongBreak
    }
    
    mutating func setNextIntervalBeforeLongBreak(_ value:Int){
        self._nextIntervalBeforeLongBreak = value
        
        if (self._nextIntervalBeforeLongBreak < self._interval) {
            while (self._interval > self._nextIntervalBeforeLongBreak){
                incrementNextIntervalBeforeLongBreak()
            }
        }
    }
}
