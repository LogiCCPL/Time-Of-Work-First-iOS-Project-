//
//  getMinutesAndWorkAtNightTests.swift
//  Time of Work Tests
//
//  Created by Robert Adamczyk on 01.01.21.
//
@testable import Time_of_Work
import XCTest

class getMinutesAndWorkAtNightTests: XCTestCase {

    var envi: ProjectEnvironment!
    
    override func setUp() {
        super.setUp()
        envi = ProjectEnvironment()
    }
    
    override func tearDown() {
        envi = nil
        super.tearDown()
    }
    
    func test_getMinutesFromDate() {
        let date = Calendar.current.date(bySettingHour: 2, minute: 10, second: 0, of: Date())
        
        let result = envi.getMinutesFromDate(date: date!)
        
        XCTAssertEqual(130, result)
        
        let date2 = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        
        let result2 = envi.getMinutesFromDate(date: date2!)
        
        XCTAssertEqual(0, result2)
        
    }
    
    func test_getMinutesFromTwoDates() {
        
        let result = envi.getMinutesFromTwoDates(dateIn: Date(), dateOut: Date())
        
        XCTAssertEqual(0, result)
        
        let date = Date()
        let date2 = Calendar.current.date(byAdding: .minute, value: 367, to: date )
        
        let result2 = envi.getMinutesFromTwoDates(dateIn: date, dateOut: date2!)
        
        XCTAssertEqual(367, result2)
    }
    
    func test_workAtNight() {
        let date = Date()
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: date )
        
        let result = envi.workAtNight(dateIn: date, dateOut: date2!)
        
        XCTAssertTrue(result)
        
        let date3 = date
        let result2 = envi.workAtNight(dateIn: date, dateOut: date3)
        XCTAssertFalse(result2)
    }

}
