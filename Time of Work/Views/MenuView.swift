//
//  ContentView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI
import PartialSheet


struct MenuView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DataBase.dateIn, ascending: false)])
    var tasks: FetchedResults<DataBase>
    @State var alert = false
    
    @State var lastCheckOut: Date?
    @State var lastMins: Int?
    @State var timeInWeek: String = ""
    @State var timeInMonth: String = ""

    
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button(action: {
                        buttonCheckInOut()
                    }){
                        HStack(spacing: 20){
                            Text(self.environment.working ? "CHECK OUT" : "CHECK IN")
                                .font(.title)
                                .bold()
                            Image(systemName: self.environment.working ? "person.fill.xmark" : "person.fill.checkmark")
                                .resizable()
                                .frame(width: 70, height: 50)

                        }
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .background(RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(Color.blue)
                                        .frame(width: 270, height: 70))
                    }.padding(.bottom, 50)
                    .alert(isPresented: $alert) {
                        Alert(title: Text("To much work !"), message: Text("You can not be 24 hours at work."), dismissButton: .default(Text("Got it!")))
                    }
                } // BUTTON CHECK IN OUT
                Spacer()
                
                
                VStack(spacing: 60) {
                    PauseFrame(work: $environment.working)
                    
                    CurrentTimeAndCheckIn()

                    LastCheckOutAndTime(lastCheckOut: $lastCheckOut, lastMins: $lastMins)
                    
                    ThisWeekAndMonth(timeInWeek: $timeInWeek, timeInMonth: $timeInMonth)
                }

            }
            .onAppear() {
                timeInWeekAndMonth()
                lastTimeVoid()
            }
            .padding(.vertical, 100)
            .navigationBarTitle("Time at Work", displayMode: .inline)
        }
    }

    private func lastTimeVoid() {
        for task in tasks {
            lastMins = Int(task.minutesOfWork)
            lastCheckOut = task.dateOut
            break
        }
    }
    private func timeInWeekAndMonth() {
        let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYearForWeekOfYear = Calendar.current.component(.yearForWeekOfYear, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        var minsOfWeek = 0
        var minsOfMonth = 0
        for task in tasks {
            if Calendar.current.component(.weekOfYear, from: task.dateIn!) == currentWeek &&
               Calendar.current.component(.yearForWeekOfYear, from: task.dateIn!) == currentYearForWeekOfYear {
                minsOfWeek += Int(task.minutesOfWork)
            }
            if Calendar.current.component(.month, from: task.dateIn!) == currentMonth &&
               Calendar.current.component(.year, from: task.dateIn!) == currentYear {
                minsOfMonth += Int(task.minutesOfWork)
            }
        }
        
        timeInWeek = environment.dateString(mins: minsOfWeek, format: .timeWithHourMins)
        
        timeInMonth = environment.dateString(mins: minsOfMonth, format: .timeWithHourMins)
    }
    private func buttonCheckInOut() {
        if !environment.working{
            environment.checkIn()
            environment.working.toggle()
        }else {
            environment.working.toggle()
            environment.checkOut()
            if environment.compareDates24H(dateIn: environment.user.getLastDateIn(), dateOut: environment.user.getLastDateOut()) {
                alert = true
            }else {
                alert = false
                let dateIn = environment.user.getLastDateIn()
                let dateOut = environment.user.getLastDateOut()
                let pause = environment.getMinutesFromDate(date: environment.user.timeOfPause)
                let work = environment.getMinutesFromTwoDates(dateIn: environment.user.getLastDateIn(),
                                                              dateOut: environment.user.getLastDateOut()) - pause
                let workAtNight = environment.workAtNight(dateIn: environment.user.getLastDateIn(), dateOut: environment.user.getLastDateOut())
                environment.addDate(viewContext, dateIn, dateOut, pause, workAtNight, work)
            }
        timeInWeekAndMonth()
        lastTimeVoid()
        }
    }
}
struct BackgroundFrame: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(colorScheme == .dark ? MyColors.darkgray : MyColors.brightgray)
                        .frame(width: 150, height: 50)
    }
}

struct PauseFrame: View {
    @EnvironmentObject var environment: ProjectEnvironment
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var work: Bool
    
    var body: some View {
        VStack(spacing: 4){
            Text("Pause: ")
            Text(work ? "\(environment.dateString(date: environment.user.timeOfPause, format: .timeWithHourMins))" : "-")
                .bold()
        }
        .frame(width: 150, height: 30)
        .background(BackgroundFrame())
    }
}

struct CurrentTimeAndCheckIn: View {
    
    @EnvironmentObject var environment: ProjectEnvironment
    @State var todayTime: String?
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 60){
            VStack(spacing: 4){
                Text("Current Check In:")
                Text(environment.working ? "\(environment.dateString(date: environment.user.getLastDateIn(), format: .shortDateAndTime))" : "-")
                    .bold()
            }
            .frame(width: 150, height: 30)
            .background(BackgroundFrame())
            VStack(spacing: 4){
                Text("Current Time:")
                if todayTime != nil && self.environment.working {
                    Text("\(todayTime!)")
                        .bold()
                        .onAppear(){
                            todayTime = environment.timeTodayString()
                        }
                }else {
                    Text("-")
                }
            }
            .frame(width: 150, height: 30)
            .background(BackgroundFrame())

        }
        .onReceive(timer) { input in
            todayTime = environment.timeTodayString()
        }
    }
}

struct LastCheckOutAndTime: View {
    
    @EnvironmentObject var environment: ProjectEnvironment
    
    @Binding var lastCheckOut: Date?
    @Binding var lastMins: Int?
    
    var body: some View {
        HStack(spacing: 60){
            VStack(spacing: 4){
                Text("Last Check Out:")
                Text(lastCheckOut != nil ? "\(environment.dateString(date: lastCheckOut!, format: .shortDateAndTime))" : "-")
                    .bold()
            }
            .frame(width: 150, height: 30)
            .background(BackgroundFrame())

            VStack(spacing: 4){
                Text("Last Time:")
                Text(lastMins != nil ? "\(environment.dateString(mins: lastMins!, format: .timeWithHourMins))" : "-")
                    .bold()
            }
            .frame(width: 150, height: 30)
            .background(BackgroundFrame())
        }
    }
}

struct ThisWeekAndMonth: View {
    
    @EnvironmentObject var environment: ProjectEnvironment
    
    @Binding var timeInWeek: String
    @Binding var timeInMonth: String
    
    var body: some View {
        HStack(spacing: 60){
            VStack(spacing: 4){
                Text("This Week:")
                Text("\(timeInWeek)")
                    .bold()
            }
            .frame(width: 150, height: 30)
            .background(BackgroundFrame())

            VStack(spacing: 4){
                Text("This Month:")
                Text("\(timeInMonth)")
                    .bold()
            }
            .frame(width: 150, height: 30)
            .background(BackgroundFrame())
        }
    }
}


struct MenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceContainer = PersistenceController.shared
        MenuView()
            .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
            .environmentObject(ProjectEnvironment())
    }
}
