//
//  NewDateView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 28.11.20.
//

import SwiftUI

enum ActiveAlert {
    case first, secund, third
}

struct dateHeader: View {
    var body: some View {
        HStack{
            Image(systemName: "calendar")
            Text("DATE")
        }
    }
}

struct timeHeader: View {
    var body: some View {
        HStack{
            Image(systemName: "clock")
            Text("Time")
        }
    }
}

struct doneHeader: View {
    var body: some View {
        HStack{
            Image(systemName: "checkmark.circle")
            Text("Save")
        }
    }
}

struct NewDateView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: [])
    var tasks: FetchedResults<DataBase>
    
    @State var dateIn: Date = Date()
    @State var dateOut: Date = Date()
    @State var pause: Date = Date()
    @State var workAtNight: Bool = false
    @State var timeAccount: Bool = false
    @State var vacation: Bool = false
    @State var publicHoliday: Bool = false
    @State var hoursFree: Int = 0
    
    @State var alert = false
    @State var activeAlert: ActiveAlert = .first
    
    @State var showDate = false
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false

    @State var showTimeIn = false
    @State var showTimeOut = false
    var body: some View {
        
        
        //VStack{
            Form {
                
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
                    NavigationLink(destination: Preferences(vacation: $vacation, publicHoliday: $publicHoliday, timeAccount: $timeAccount)){
                        Text("Preferences")
                    }
                }
                
                

                
                Section(header: timeHeader()) {
                    
                    if !vacation && !publicHoliday {
                        
                        Button(action: {
                            self.show1.toggle()
                            self.showTimeIn = true
                        })
                        {
                            HStack{
                                Text("Start time: ")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Text(showTimeIn ? "\(environment.dateString(date: dateIn, format: .shortTime))" : "")
                            }
                        }
                        if show1 {
                            DatePicker("Start time: ", selection: $dateIn, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                        }
                        
                        Button(action: {
                            self.show2.toggle()
                            self.showTimeOut = true
                        }){
                            HStack{
                                Text("End time: ")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Text(showTimeOut ? "\(environment.dateString(date: dateOut, format: .shortTime))" : "")
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
                            showTimeIn = true
                            showTimeOut = true
                        })
                        {
                            HStack{
                                Text("Count Hours: ")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Text(showTimeIn ? "\(hoursFree) hours" : "")
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
                            setDates()
                            if !self.showTimeOut || !self.showTimeIn {
                                activeAlert = .third
                                alert = true
                            }
                            else if environment.compareDates(dateIn: dateIn, dateOut: dateOut) && !vacation && !publicHoliday {
                                activeAlert = .first
                                alert = true
                            }
                            else if environment.compareDates24H(dateIn: dateIn, dateOut: dateOut) && !vacation && !publicHoliday{
                                activeAlert = .secund
                                alert = true
                            }
                            else {
                                alert = false
                            }
                            
                            if !alert {
                                if !vacation && !publicHoliday {
                                    let pausee = environment.getMinutesFromDate(date: pause)
                                    let work = environment.getMinutesFromTwoDates(dateIn: dateIn, dateOut: dateOut) - pausee
                                    environment.addDate(viewContext, dateIn, dateOut, pausee, workAtNight, work, timeAccount)
                                }else {
                                    environment.addDate(viewContext, dateIn, dateIn, 0, false, hoursFree * 60, timeAccount, vacation, publicHoliday)
                                }
                                
                                presentationMode.wrappedValue.dismiss()
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
                            }.onAppear(){
                                pause = self.environment.user.timeOfPause
                            }
                        Spacer()
                    }
                }
                
                
                
            }
            .navigationBarTitle("New Date", displayMode: .inline)
            .onAppear() {
                timeAccount = environment.user.getTimeAccountActive()
                showDate = false
                show1 = false
                show2 = false
                show3 = false

                showTimeIn = false
                showTimeOut = false
            }
    }
    
    func setDates() {
        let h = Calendar.current.component(.hour, from: dateOut)
        let m = Calendar.current.component(.minute, from: dateOut)
        let h2 = Calendar.current.component(.hour, from: dateIn)
        let m2 = Calendar.current.component(.minute, from: dateIn)
        
        dateIn = Calendar.current.date(bySettingHour: h2, minute: m2, second: 0, of: dateIn)!

        
        if workAtNight {
            dateOut = Calendar.current.date(byAdding: .day, value: 1, to: dateIn)!
            dateOut = Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: dateOut)!
        }else {
            dateOut = dateIn
            dateOut = Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: dateOut)!
        }
        
    }
}

struct Preferences: View {
    @Binding var vacation: Bool
    @Binding var publicHoliday: Bool
    @Binding var timeAccount: Bool
    
    var body: some View {
        Form {
            Section(header: userHeader()) {
                Toggle(isOn: $timeAccount) {
                    Text("Time Account")
                }
                Toggle(isOn: $vacation) {
                    Text("Vacation")
                }
                .onChange(of: vacation) { _ in
                    if vacation {
                        publicHoliday = false
                    }
                }
                Toggle(isOn: $publicHoliday) {
                    Text("Public Holiday")
                }
                .onChange(of: publicHoliday) { _ in
                    if publicHoliday {
                        vacation = false
                    }
                }
            }
        }
        .navigationBarTitle("Preferences", displayMode: .inline)
    }
}

struct NewDateView_Previews: PreviewProvider {
    static var previews: some View {
        NewDateView().environmentObject(ProjectEnvironment())
    }
}
