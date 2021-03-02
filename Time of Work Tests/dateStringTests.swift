//
//  dateStringTests.swift
//  Time of Work Tests
//
//  Created by Robert Adamczyk on 31.12.20.
//
@testable import Time_of_Work
import XCTest

class dateStringTests: XCTestCase {

    var envi: ProjectEnvironment!
    var date: Date!
    
    override func setUp() {
        super.setUp()
        date = setDateToTest()
        envi = ProjectEnvironment()
    }
    
    override func tearDown() {
        envi = nil
        date = nil
        super.tearDown()
    }
    
    func setDateToTest() -> Date {
        var date = Calendar.current.date(bySetting: .year, value: 2035, of: Date())
        date = Calendar.current.date(bySetting: .month, value: 2, of: date!)
        date = Calendar.current.date(bySetting: .day, value: 13, of: date!)
        date = Calendar.current.date(bySettingHour: 13, minute: 45, second: 0, of: date!)
        return date!
    }
    
    func test_error_mins_date_have_novalue() {
        let result = envi.dateString(format: .longDateAndTime)
        
        XCTAssertEqual(result, "#error func dateString")
    }
    func test_date_shortTime() {
        let result = envi.dateString(date: date, format: .shortTime)
        
        XCTAssertEqual(result, "13:45")
    }
    func test_date_timeWithHourMins() {
        let result = envi.dateString(date: date, format: .timeWithHourMins)
        
        XCTAssertEqual(result, "13h 45m")
    }
    func test_date_longDate() {
        let result = envi.dateString(date: date, format: .longDate)
        
        XCTAssertEqual(result, "Tue 13 Feb 2035")
    }
    func test_date_longDateAndTime() {
        let result = envi.dateString(date: date, format: .longDateAndTime)
        
        XCTAssertEqual(result, "Tue 13 Feb 2035 13:45")
    }
    func test_date_shortDateAndTime() {
        let result = envi.dateString(date: date, format: .shortDateAndTime)
        
        XCTAssertEqual(result, "13 Feb 13:45")
    }
    
    ///MINS
    
    func test_mins_shortTime() {
        let result = envi.dateString(mins: 7894, format: .shortTime)
        
        XCTAssertEqual(result, "131:34")
        let result2 = envi.dateString(mins: 61, format: .shortTime)
        
        XCTAssertEqual(result2, "01:01")
        let result3 = envi.dateString(mins: 0, format: .shortTime)
        
        XCTAssertEqual(result3, "00:00")
        
    }
    func test_mins_timeWithHourMins() {
        let result = envi.dateString(mins: -7894, format: .timeWithHourMins)
        
        XCTAssertEqual(result, "-131h 34m")
        let result2 = envi.dateString(mins: -61, format: .timeWithHourMins)
        
        XCTAssertEqual(result2, "-01h 01m")
        let result3 = envi.dateString(mins: 0, format: .timeWithHourMins)
        
        XCTAssertEqual(result3, "00h 00m")
    }


}
