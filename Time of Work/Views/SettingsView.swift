//
//  SettingsView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 28.12.20.
//

import SwiftUI
import PartialSheet

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var environment: ProjectEnvironment

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: userHeader()) {
                    NavigationLink(destination: TimeAccount()){
                        Text("Time Account")
                    }
                    NavigationLink(destination: Pause()){
                        Text("Pause")
                    }
                    
                }
                Section(header: infoHeader()) {
                    NavigationLink(destination: About()){
                        Text("About")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        About().environmentObject(ProjectEnvironment())
    }
}

struct userHeader: View {
    var body: some View {
        HStack(){
            Image(systemName: "person")
            Text("user preferences")
        }
    }
}
struct infoHeader: View {
    var body: some View {
        HStack(){
            Image(systemName: "info.circle")
            Text("info")
        }
    }
}

struct Pause: View {
    var body: some View {
        Form{
            Section{
                PauseButton()
            }
        }
        .navigationBarTitle("Pause", displayMode: .inline)
    }
}

struct TimeAccount: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var environment: ProjectEnvironment
    @State var timeAccount: Bool = false
    @State var showInput: Bool = false
    @State var showPicker: Bool = false
    @State var showPickerForDays = false
    @State var time: Float = 0
    @State var timeForWeek: Int = 40
    @State var daysInWeek: Int = 5
    @State var showAlert = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DataBase.dateIn, ascending: false)])
    var tasks: FetchedResults<DataBase>
    
    var body: some View {
        VStack{
            Form{
                Section(footer: Text("Activation will track the current status of your time account.")){
                    Toggle(isOn: $timeAccount) {
                        Text("Activate Time Account")
                    }
                    .alert(isPresented:$showAlert) {
                                Alert(title: Text("Are you sure you want to turn off this?"), message: Text("This will clear your account time. History will remain."), primaryButton: .destructive(Text("Turn off")) {
                                        environment.user.setTimeAccountActive(value: timeAccount)
                                        environment.user.setTimeAccount(value: 0)
                                        time = 0
                                        for task in tasks {
                                            task.timeAccountStatus = false
                                        }
                                        environment.saveContext(viewContext)
                                }, secondaryButton: .cancel() {
                                        environment.user.setTimeAccountActive(value: !timeAccount)
                                        timeAccount = !timeAccount
                                })
                            }
                    
                    .onChange(of: timeAccount) { new in
                        if new == false {
                            showAlert = true
                        }else{
                            environment.user.setTimeAccountActive(value: timeAccount)
                        }
                    }
                }
                if timeAccount {
                    Section(footer: Text("It doesn't show the current account balance. Set only when the actual account balance is different.")) {
                        Button(action: {
                            showInput.toggle()
                        }){
                            HStack {
                                Text("Time Account")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Text("\(String(format: "%.2f", time))")
                            }
                        }
                        .sheet(isPresented: $showInput){
                            InputView(resultFloat: $time, showSheet: $showInput)
                        }
                    }
                    Section(footer: Text("Set the values ​​from the employment contract.")) {
                        
                        Button(action: {
                            showPicker.toggle()
                        }){
                            HStack{
                                Text("Time For Week")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Text("\(timeForWeek).00")
                            }
                        }
                        if showPicker {
                            Picker("Time For Week", selection: $timeForWeek){
                                ForEach(10...50, id: \.self) { i in
                                    if i%5 == 0 {
                                        Text("\(i) hours / week")
                                    }
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                            .onChange(of: timeForWeek) { new in
                                environment.user.setTimeForWeek(value: timeForWeek)
                            }
                        }
                        Button(action: {
                            showPickerForDays.toggle()
                        }){
                            HStack{
                                Text("Count Days pro Week")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Text("\(daysInWeek).00")
                            }
                        }
                        if showPickerForDays {
                            Picker("Count Days pro Week", selection: $daysInWeek){
                                ForEach(1...7, id: \.self) { i in
                                    Text("\(i) days")
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                            .onChange(of: daysInWeek) { new in
                                environment.user.setDaysOfWork(value: daysInWeek)
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            timeAccount = environment.user.getTimeAccountActive()
            time = environment.user.getTimeAccount()
            timeForWeek = environment.user.getTimeForWeek()
            daysInWeek = environment.user.getDaysOfWork()
        }
        .navigationBarTitle("Time Account", displayMode: .inline)
    }
}

struct About: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            Image("icon2000")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .cornerRadius(25)
                .shadow(color: colorScheme == .dark ? .white : .black, radius: 5)
                .padding()
            HStack{
                Spacer()
                VStack{
                    Text("Version: 1.0.0")
                    Text("Made by Robert Adamczyk")
                        
                }.font(.subheadline)
                Spacer()
            }
            Form{
                Section(header: Text("About")) {
                    HStack {
                        Spacer()
                        Text("The app was made to keep track of your working hours as simple as possible. If you like it, leave a review on the AppStore. Thanks for using my application. ❤️❤️❤️ ")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarTitle("About", displayMode: .inline)
    }
}

struct PauseButton: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var environment: ProjectEnvironment
    
    @State var showPause = false
    var body: some View {
        Button(action: {
            self.showPause.toggle()
        })
        {
            HStack{
                Text("Default Pause: ")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(environment.dateString(date: environment.user.timeOfPause, format: .shortTime))")
            }
        }
        if showPause {
            DatePicker("Pause: ", selection: self.$environment.user.timeOfPause, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                
        }
    }
}
