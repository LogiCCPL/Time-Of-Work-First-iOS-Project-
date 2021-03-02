//
//  RowOfMyTimeView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 18.12.20.
//

import SwiftUI

struct RowOfMyTimeView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    
    
    @State var week: Int
    @State var year: Int
    @State var minsPerWeek: Int
    
    var body: some View {
        VStack(spacing: -5){
            HStack {
                HStack{
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                    Text("Week:")
                    Text("\(week)/\(String(year))")
                        .bold()
                }
                Spacer()
                HStack{
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                    Text("Your Time:")
                    Text("\(environment.dateString(mins: minsPerWeek, format: .shortTime))")
                        .bold()
                }
            }
            .padding(.leading, 5)
            .font(.system(size: 15))
            if environment.user.getTimeAccountActive() {
                HStack{
                    Spacer()
                    Text("\( String(format: "%.2f", Float(minsPerWeek - environment.user.getTimeForWeek() * 60) / 60) )")
                        .foregroundColor( (Float(minsPerWeek - environment.user.getTimeForWeek() * 60) / 60) < 0 ? .red : .green)
                        .font(.system(size: 11))
                }
            }
        }
    }
}

struct RowOfMyTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RowOfMyTimeView(week: 51, year: 2020, minsPerWeek: 2521).environmentObject(ProjectEnvironment())
    }
}
