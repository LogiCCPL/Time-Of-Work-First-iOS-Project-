//
//  CoreDataMenager.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 03.01.21.
//

import Foundation
import SwiftUI

class CoreDataMenager {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DataBase.dateIn, ascending: false)])
    var tasks: FetchedResults<DataBase>
    
    func xddd() {
        for task in tasks {
            print(task.dateIn!)
        }
    }
}
