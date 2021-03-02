//
//  RowOfDateView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI

struct RowOfDateView: View {
    @EnvironmentObject var environment: ProjectEnvironment
    let dateIn: Date
    let dateOut: Date
    let timeAccount: Bool
    let workAtNight: Bool
    let vacation: Bool
    let publicHoliday: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            HStack{
                Image(systemName: vacation || publicHoliday ? "calendar.circle" : "arrowshape.turn.up.right.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.green)
                Text(vacation || publicHoliday ? environment.dateString(date: dateIn, format: .longDate) : environment.dateString(date: dateIn, format: .longDateAndTime))
                    .font(.subheadline)
                    .bold()
                Spacer()
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(timeAccount ? .blue : .gray)
                    .padding(.trailing, 15)
                
            }
            HStack{
                Image(systemName: vacation || publicHoliday ? "info.circle" : "arrowshape.turn.up.left.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.red)
                Text(vacation || publicHoliday ? displayInfo() : environment.dateString(date: dateOut, format: .longDateAndTime))
                    .font(.subheadline)
                    .bold()
                Spacer()
                Image(systemName: "moon.circle")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(workAtNight ? .blue : .gray)
                    .padding(.trailing, 15)
            }
            
        }
        .frame(width: 220, height: 60, alignment: .leading)
        
    }
    
    func displayInfo() -> String { return vacation ? "Vacation" : "Public Holiday" }
}

struct RowOfDateView_Previews: PreviewProvider {
    static var previews: some View {
        RowOfDateView(dateIn: Date(), dateOut: Date(), timeAccount: true, workAtNight: true, vacation: true, publicHoliday: false).environmentObject(ProjectEnvironment())
    }
}
