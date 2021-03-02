//
//  ProjectEnvironment.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 28.11.20.
//

import Foundation
import SwiftUI
import CoreData

struct WeekAndYear {
    var week: Int
    var year: Int
}
enum DateFormat: String {
    case shortTime = "HH:mm"
    case shortDateAndTime = "dd MMM HH:mm"
    case longDate = "EEE dd MMM yyyy"
    case longDateAndTime = "EEE dd MMM yyyy HH:mm"
    case timeWithHourMins = "HH'h' mm'm'"
}

class ProjectEnvironment: ObservableObject {
    @Published var user = User()
    @Published var arrayOfWeeksAndYears: [WeekAndYear] = []
    @Published var arrayOfMinutesOfWeek: [Int] = []
    
    @Published var working: Bool {
        didSet {
            UserDefaults.standard.set(working, forKey: workingKey)
        }
    }

    
    init() {
        self.working = UserDefaults.standard.bool(forKey: workingKey)
    }
    
    private let workingKey: String = "working"
    
    func checkIn() {
        user.setLastDateIn(newDate: Date())
    }
    func checkOut() {
        user.setLastDateOut(newDate: Date())
    }
    func compareDates24H(dateIn: Date, dateOut: Date) -> Bool {
        if abs(dateIn.timeIntervalSince(dateOut)) >= 86400 {
            return true
        }else {
            return false
        }
    }
    func compareDates(dateIn: Date, dateOut: Date) -> Bool {
        if dateIn >= dateOut {
            return true
        } else {
            return false
        }
    }
    func dateString(mins: Int? = nil, date: Date? = nil, format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        if date != nil {
            return formatter.string(from: date!)
        }
        else if mins != nil && date == nil && mins! < 24 * 60 && mins! > -24 * 60 {
            let hour = abs(mins! / 60)
            let min = abs(mins! % 60)
            let dateTime = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: Date())
            return mins! < 0 ? "-" + formatter.string(from: dateTime!) : formatter.string(from: dateTime!)
        }
        else if mins != nil && date == nil {
            let min = abs(mins! % 60)
            let hour = abs(mins! / 60)
            let dateTime = Calendar.current.date(bySettingHour: 0, minute: min, second: 0, of: Date())
            let str = formatter.string(from: dateTime!)
            let replaced = str.replacingOccurrences(of: "00", with: "\(hour)")
            return mins! < 0 ? "-" + replaced : replaced
        }
        else {
            return "#error func dateString"
        }
        
    }
    func getMinutesFromDate(date: Date) -> Int {
        let componentH = Calendar.current.component(.hour, from: date)
        let componentM = Calendar.current.component(.minute, from: date)
        return componentH * 60 + componentM
    }
    func getMinutesFromTwoDates(dateIn: Date, dateOut: Date) -> Int{
        let secunds = abs(dateIn.timeIntervalSince(dateOut))
        let minutes = Int(secunds/60)
        return minutes
    }
    func workAtNight(dateIn: Date, dateOut: Date) -> Bool {
        if (Calendar.current.component(.day, from: dateIn) != Calendar.current.component(.day, from: dateOut)) {
            return true
        } else {
            return false
        }
    }
    
    func addDate(_ viewContext: NSManagedObjectContext,_ dateIn: Date,_ dateOut: Date,_ minPause: Int,_ atNight: Bool,_ minWork: Int,_ timeAccount: Bool? = nil,_ vacation: Bool? = nil ,_ publicHoliday: Bool? = nil) {
        let newDate = DataBase(context: viewContext)
        newDate.dateIn = dateIn
        newDate.dateOut = dateOut
        newDate.minutesOfPause = Int16(minPause)
        newDate.workAtNight = atNight
        newDate.minutesOfWork = Int16(minWork)
        if timeAccount == nil {
            newDate.timeAccountStatus = user.getTimeAccountActive()
        }else {
            newDate.timeAccountStatus = timeAccount!
        }
        newDate.vacation = vacation != nil ? vacation! : false
        newDate.publicHoliday = publicHoliday != nil ? publicHoliday! : false
        
        saveContext(viewContext)
    }
    func saveContext(_ viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        }catch {
            let error = error as NSError
            fatalError("Unresolver error: \(error)")
        }
    }
    
    func timeTodayString() -> String {
        let mins = getMinutesFromTwoDates(dateIn: user.getLastDateIn(), dateOut: Date()) - getMinutesFromDate(date: user.timeOfPause)
        return dateString(mins: mins, format: .timeWithHourMins)
    }
}


