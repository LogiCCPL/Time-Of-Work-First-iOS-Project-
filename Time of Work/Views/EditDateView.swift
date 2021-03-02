//
//  EditDateView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 10.12.20.
//

import SwiftUI

struct EditDateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var environment: ProjectEnvironment
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var editDateSheet: Bool
    
    @State var taskToUpdate_: FetchedResults<DataBase>.Element?
    
    @State var dateIn: Date = Date()
    @State var dateOut: Date = Date()
    @State var minutesOfWork: Int16 = 0
    @State var minutesOfPause: Int16 = 0
    @Binding var workAtNight: Bool
    @State var timeAccount: Bool = false
    @State var vacation: Bool = false
    @State var publicHoliday: Bool = false
    @State var hoursFree: Int = 0
    
    @State var timeWorkIn: Date = Date()
    @State var timeWorkOut: Date = Date()
    @State var pause: Date = Date()
    
    @State var alert = false
    @State var activeAlert: ActiveAlert = .first
    
    @State var showDate = false
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false
    @State var showTime = false
    @State var firstTime = true
    
    var body: some View {
        Form{
            Section(header: dateHeader()) {
                Button(action: {
                    self.showDate.toggle()
                }){
                    HStack{
                        Text("Date of work: ")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                        Text("\(environment.dateString(date: dateIn, format: .longDate))")
                    }
                }
                if showDate {
                    DatePicker("Start time: ", selection: $dateIn, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                }
                if !vacation && !publicHoliday {
                    Toggle(isOn: $workAtNight) {
                        Text("Work At The Night")
                    }
                    if workAtNight {
                        HStack{
                            Text("Work from")
                            Text("\(environment.dateString(date: dateIn, format: .longDate))").bold()
                            Text("to")
                            Text("\(environment.dateString(date: Calendar.current.date(byAdding: .day, value: 1,to:dateIn)!, format: .longDate))")
                                .bold()
                        }
                            
                    }
                }
                
            }
            
            Section(header: userHeader()) {
                NavigationLink(destination: Preferences(vacation: $vacation, publicHoliday: $publicHoliday, timeAccount: $timeAccount).onAppear(){
                    firstTime = false
                }){
                    Text("Preferences")
                }
            }
            
            Section(header: timeHeader()) {
                if !vacation && !publicHoliday {
                    Button(action: {
                        self.show1.toggle()
                    })
                    {
                        HStack{
                            Text("Start time: ")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("\(environment.dateString(date: dateIn, format: .shortTime))")
                        }
                    }
                    if show1 {
                        DatePicker("Start time: ", selection: $dateIn, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    Button(action: {
                        self.show2.toggle()
                    }){
                        HStack{
                            Text("End time: ")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("\(environment.dateString(date: dateOut, format: .shortTime))")
                        }
                    }
                    if show2 {
                        DatePicker("End time: ", selection: $dateOut, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    Button(action: {
                        self.show3.toggle()
                    }){
                        HStack{
                            Text("Pause time: ")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("\(environment.dateString(date: pause, format: .shortTime))")
                        }
                    }
                    if show3 {
                        DatePicker("Pause time: ", selection: $pause, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    }
                }else {
                    Button(action: {
                        show1.toggle()
                        showTime = true
                    })
                    {
                        HStack{
                            Text("Count Hours: ")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text(showTime ? "\(hoursFree) hours" : "")
                        }
                    }
                    if show1 {
                        Picker("Hours: ", selection: $hoursFree){
                            ForEach(0...10, id: \.self) { i in
                                Text("\(i) hours")
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                    }
                }
            }
            Section(header: doneHeader()) {
                HStack{
                    Spacer()
                    Button(action: {
                        setDateOut()
                        if environment.compareDates(dateIn: dateIn, dateOut: dateOut) && !vacation && !publicHoliday {
                            activeAlert = .first
                            alert = true
                        }
                        else if environment.compareDates24H(dateIn: dateIn, dateOut: dateOut) && !vacation && !publicHoliday {
                            activeAlert = .secund
                            alert = true
                        }else if !showTime && ( vacation || publicHoliday ) {
                            activeAlert = .third
                            alert = true
                        }
                        else {
                            alert = false
                        }
                        if !alert {
                            changeValues()
                            environment.saveContext(viewContext)
                            self.editDateSheet.toggle()
                        }
                        
                    }){
                        Text("Done")
                            .bold()
                    }
                    .alert(isPresented: $alert) {
                        
                        switch activeAlert {
                        
                        case .first:
                            return Alert(title: Text("Wrong Dates !"), message: Text("The start date cannot be greater or equals than the end date."), dismissButton: .default(Text("Back")))
                        case .secund:
                            return Alert(title: Text("To much work !"), message: Text("The end date cannot be greater than 24 hours from the start date."), dismissButton: .default(Text("Back")))
                        case .third:
                            return Alert(title: Text("Date is missing !"), message: Text("Complete the fields of time."), dismissButton: .default(Text("Back")))
                        }
                    }
                    Spacer()
                }
            }
           
            
            
        }.onAppear(){
            showDate = false
            show1 = false
            show2 = false
            show3 = false
            dateIn = taskToUpdate_?.dateIn ?? Date()
            dateOut = taskToUpdate_?.dateOut ?? Date()
            minutesOfWork = taskToUpdate_?.minutesOfWork ?? 0
            minutesOfPause = taskToUpdate_?.minutesOfPause ?? 0
            workAtNight = taskToUpdate_?.workAtNight ?? false
            if firstTime {
                timeAccount = taskToUpdate_?.timeAccountStatus ?? false
                vacation = taskToUpdate_?.vacation ?? false
                publicHoliday = taskToUpdate_?.publicHoliday ?? false
                if publicHoliday || vacation {
                    hoursFree = Int(minutesOfWork / 60)
                    showTime = true
                }
            }
            
            let hour = Int(minutesOfPause/60)
            let min = Int(minutesOfPause%60)
            
            pause = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: Date()) ?? Date() // <------
            // WARNING TO DO DANGER ! ! !@ @# !@# !@# !!
        }
        .navigationBarTitle("Edit Date", displayMode: .inline)
        
    }
    private func changeValues() {
        taskToUpdate_?.dateIn = dateIn
        taskToUpdate_?.dateOut = !vacation && !publicHoliday ? dateOut : dateIn
        taskToUpdate_?.workAtNight = !vacation && !publicHoliday ? workAtNight : false
        taskToUpdate_?.minutesOfPause = !vacation && !publicHoliday ? Int16(environment.getMinutesFromDate(date: pause)) : 0
        taskToUpdate_?.timeAccountStatus = timeAccount
        taskToUpdate_?.vacation = vacation
        taskToUpdate_?.publicHoliday = publicHoliday
        let minsTemp = environment.getMinutesFromTwoDates(dateIn: dateIn,
                                                          dateOut: dateOut) - environment.getMinutesFromDate(date: pause)
        taskToUpdate_?.minutesOfWork = !vacation && !publicHoliday ? Int16(minsTemp) : Int16(hoursFree * 60)
    }
    private func setDateOut() {
        var tempDate: Date
        if workAtNight {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: dateIn)!
        }else {
            tempDate = dateIn
        }
        
        let componentH = Calendar.current.component(.hour, from: dateOut )
        let componentM = Calendar.current.component(.minute, from: dateOut)
        tempDate = Calendar.current.date(bySettingHour: componentH, minute: componentM, second: 0, of: tempDate)!
        dateOut = tempDate
    }
}

struct EditDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditDateView(editDateSheet: .constant(false), workAtNight: .constant(false)).environmentObject(ProjectEnvironment())
    }
}
