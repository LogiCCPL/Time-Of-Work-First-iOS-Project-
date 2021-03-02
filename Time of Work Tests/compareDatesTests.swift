//
//  compareDatesTests.swift
//  Time of Work Tests
//
//  Created by Robert Adamczyk on 01.01.21.
//

@testable import Time_of_Work
import XCTest

class compareDatesTests: XCTestCase {
    var envi: ProjectEnvironment!
    
    override func setUp() {
        super.setUp()
        envi = ProjectEnvironment()
    }
    
    override func tearDown() {
        envi = nil
        super.tearDown()
    }
    
    func test_compareDates() {
        let dateIn = Date()
        let dateOut = Calendar.current.date(byAdding: .second, value: 1, to: dateIn)!
        
        let result = envi.compareDates(dateIn: dateIn, dateOut: dateOut)
        
        XCTAssertFalse(result)
        
        let result2 = envi.compareDates(dateIn: dateOut, dateOut: dateIn)
        
        XCTAssertTrue(result2)
        
        let date = Date()
        let result3 = envi.compareDates(dateIn: date, dateOut: date)
        
        XCTAssertTrue(result3)
    }
    
    func test_compareDates24H() {
        // 86400 sec = 1 DAY
        var dateIn = Date()
        var dateOut = Calendar.current.date(byAdding: .second, value: 86400, to: dateIn)!
        
        let result = envi.compareDates24H(dateIn: dateIn, dateOut: dateOut)
        
        XCTAssertTrue(result)
        
        let result2 = envi.compareDates24H(dateIn: dateOut, dateOut: dateIn)
        
        XCTAssertTrue(result2)
        
        dateIn = Date()
        dateOut = Calendar.current.date(byAdding: .second, value: 86399, to: dateIn)!
        
        let result3 = envi.compareDates24H(dateIn: dateIn, dateOut: dateOut)
        
        XCTAssertFalse(result3)
        
        let result4 = envi.compareDates24H(dateIn: dateOut, dateOut: dateIn)
        
        XCTAssertFalse(result4)
    }
}
