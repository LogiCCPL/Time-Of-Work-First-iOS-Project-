//
//  UserExtension.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 28.11.20.
//

import Foundation

extension User {
    
    func minutesOfWork(dateIn: Date, dateOut: Date, pause: Int) -> Int{
        let secundsOfWork = abs(dateIn.timeIntervalSince(dateOut))
        let timeOfMinutes = Int(secundsOfWork/60) - pause
        return timeOfMinutes
    }

}
