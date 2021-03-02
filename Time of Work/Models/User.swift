//
//  User.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import Foundation
class User {
    private var lastOfDateIn: Date
    private var lastOfDateOut: Date
    var timeOfPause: Date {
        didSet {
            UserDefaults.standard.set(timeOfPause, forKey: timeOfPauseKey)
        }
    }

    private let lastOfDateInKey: String = "lastDateIn"
    private let lastOfDateOutKey: String = "lastDateOut"
    private let timeOfPauseKey: String = "timeOfPause"
    
    private var timeAccountActive: Bool
    private var timeAccount: Float
    private var timeForWeek: Int
    private var daysOfWork: Int
    
    private let timeAccountActiveKey: String = "timeAccountActive"
    private let timeAccountKey: String = "timeAccount"
    private let timeForWeekKey: String = "timeForWeek"
    private let daysOfWorkKey: String = "daysOfWork"
    
    
    init() {
        self.lastOfDateIn = UserDefaults.standard.object(forKey: lastOfDateInKey) as? Date ?? Date()
        self.lastOfDateOut = UserDefaults.standard.object(forKey: lastOfDateOutKey) as? Date ?? Date()
        self.timeOfPause = UserDefaults.standard.object(forKey: timeOfPauseKey) as? Date ?? Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
        self.timeAccountActive = UserDefaults.standard.bool(forKey: timeAccountActiveKey)
        self.timeAccount = UserDefaults.standard.float(forKey: timeAccountKey)
        self.timeForWeek = UserDefaults.standard.object(forKey: timeForWeekKey) as? Int ?? 40
        self.daysOfWork = UserDefaults.standard.object(forKey: daysOfWorkKey) as? Int ?? 5
    }
    

    func getLastDateIn() -> Date { return self.lastOfDateIn }
    func getLastDateOut() -> Date { return self.lastOfDateOut }
    func getTimeAccountActive() -> Bool { return self.timeAccountActive }
    func getTimeAccount() -> Float { return self.timeAccount }
    func getTimeForWeek() -> Int { return self.timeForWeek }
    func getDaysOfWork() -> Int { return self.daysOfWork }
    
    func setLastDateIn(newDate: Date) {
        self.lastOfDateIn = newDate
        UserDefaults.standard.set(self.lastOfDateIn, forKey: lastOfDateInKey)
    }
    func setLastDateOut(newDate: Date) {
        self.lastOfDateOut = newDate
        UserDefaults.standard.set(self.lastOfDateOut, forKey: lastOfDateOutKey)
    }
    func setTimeAccountActive(value: Bool) {
        self.timeAccountActive = value
        UserDefaults.standard.set(self.timeAccountActive, forKey: timeAccountActiveKey)
    }
    func setTimeAccount(value: Float) {
        self.timeAccount = value
        UserDefaults.standard.set(self.timeAccount, forKey: timeAccountKey)
    }
    func setTimeForWeek(value: Int) {
        self.timeForWeek = value
        UserDefaults.standard.set(self.timeForWeek, forKey: timeForWeekKey)
    }
    func setDaysOfWork(value: Int) {
        self.daysOfWork = value
        UserDefaults.standard.set(self.daysOfWork, forKey: daysOfWorkKey)
    }
}
