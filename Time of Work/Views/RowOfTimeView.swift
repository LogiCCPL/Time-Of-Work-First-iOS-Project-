//
//  RowOfTimeView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI

struct RowOfTimeView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    let dateIn: Date
    let dateOut: Date
    let minutesOfPause: Int
    let minutesOfWork: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack {
                Image(systemName: "timer")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.blue)
                Text("Work: \(environment.dateString(mins: minutesOfWork, format: .shortTime)) ")
                    .font(.subheadline)
                    .bold()
            }
            HStack(){
                Image(systemName: "pause.circle")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.blue)
                Text("Pause: \(environment.dateString(mins: minutesOfPause, format: .shortTime))")
                    .font(.subheadline)
                    .bold()
            }
        }
    }
   
}

struct RowOfTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RowOfTimeView(dateIn: Date(), dateOut: Date(), minutesOfPause: 15, minutesOfWork: 75).environmentObject(ProjectEnvironment())
    }
}
