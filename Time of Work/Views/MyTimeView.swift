//
//  MyTimeView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 28.11.20.
//

import SwiftUI



struct MyTimeView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DataBase.dateIn, ascending: false)])
    var tasks: FetchedResults<DataBase>
    
    @State var pause: Date = Date()
    @State var numberOfWeek: Int = Calendar.current.component(.weekOfYear, from: Date())
    @State var showDetail: Bool = false
    @State var timeAccount: Float = 0

    var body: some View {
        NavigationView{
            VStack {
                VStack {
                    Text("Your Time Account: ")
                        .font(.system(size: 25))
                    Text(environment.user.getTimeAccountActive() ? "\(String(format: "%.2f", environment.user.getTimeAccount() + timeAccount))" : "Active account in settings.")
                        .font(environment.user.getTimeAccountActive() ? .system(size: 20, weight: .bold) : .system(size: 15))
                        .padding(.top, 5)
                }.padding()
                List {
                    
                    Section(header: Text("List of Time")) {
                        ForEach(self.environment.arrayOfWeeksAndYears.indices, id: \.self) { i in
                            RowOfMyTimeView(week: self.environment.arrayOfWeeksAndYears[i].week, year: self.environment.arrayOfWeeksAndYears[i].year, minsPerWeek: self.environment.arrayOfMinutesOfWeek[i])
                        }
                    }
                    
                }
                .listStyle(GroupedListStyle())
                
            }
            .navigationBarTitle("My Time", displayMode: .inline)
        }
        .onAppear {
            var array: [WeekAndYear] = []
            var arrayMins: [Int] = []
            var temp: WeekAndYear = WeekAndYear(week: 0, year: 0)
            for task in tasks {
                if( temp.week != Calendar.current.component(.weekOfYear, from: task.dateIn!)) {
                    let temp2 = WeekAndYear(week: Calendar.current.component(.weekOfYear, from: task.dateIn!), year: Calendar.current.component(.yearForWeekOfYear, from: task.dateIn!))
                    array.append(temp2)
                    temp = temp2
                    arrayMins.append(Int(task.minutesOfWork))
                } else {
                    arrayMins[arrayMins.endIndex-1] += Int(task.minutesOfWork)
                }
                if task.timeAccountStatus {
                    timeAccount += Float(task.minutesOfWork) / 60 - Float(environment.user.getTimeForWeek() / environment.user.getDaysOfWork())
                }
            }
            environment.arrayOfMinutesOfWeek = arrayMins
            environment.arrayOfWeeksAndYears = array
        }
        
    }
}

struct MyTimeView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimeView().environmentObject(ProjectEnvironment())
    }
}
