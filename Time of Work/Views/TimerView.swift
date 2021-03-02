//
//  TimerView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 19.12.20.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var date: String?
    @State var time: String?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack{
            Text("\(date ?? "")")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .bold()
                .onReceive(timer) { input in
                    self.date = returnStringDate(date: Date())
                }
            Text("\(time ?? "")")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .onReceive(timer) { input in
                    self.time = returnStringTime(date: Date())
                }
        }.onAppear() {
            date = returnStringDate(date: Date())
            time = returnStringTime(date: Date())
        }
        
    }
    func returnStringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM yyyy"
        
        return formatter.string(from: date)
    }
    func returnStringTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(from: date)
    }

}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(date: "EEE dd MMM yyyy", time: "HH:mm:ss")
    }
}

