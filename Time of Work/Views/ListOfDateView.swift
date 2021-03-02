//
//  ListOfDateView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI
import PartialSheet

struct ListOfDateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DataBase.dateIn, ascending: false)])
    var tasks: FetchedResults<DataBase>

    @State var addDateSheet = false
    @State var editDateSheet = false
    @State var taskToUpdate: FetchedResults<DataBase>.Element?
    @State var workAtNight: Bool = false
    
    
    var body: some View {
        
        NavigationView {
            
            List{
                ForEach(tasks) { task in
                    HStack(spacing: 0) {
                        RowOfDateView(dateIn: task.dateIn ?? Date(), dateOut: task.dateOut ?? Date(), timeAccount: task.timeAccountStatus, workAtNight: task.workAtNight, vacation: task.vacation, publicHoliday: task.publicHoliday)
                        RowOfTimeView(dateIn: task.dateIn ?? Date(), dateOut: task.dateOut ?? Date(), minutesOfPause: Int(task.minutesOfPause), minutesOfWork: Int(task.minutesOfWork))
                    }
                    .onTapGesture {
                        workAtNight = task.workAtNight
                        taskToUpdate = task
                        self.editDateSheet.toggle()
                    }
                }
                .onDelete(perform: deleteDates)
                //.listRowBackground(Color.black.opacity(0.1))
                
            }
            .background(
                NavigationLink(destination: EditDateView(editDateSheet: $editDateSheet, taskToUpdate_: taskToUpdate, workAtNight: $workAtNight), isActive: $editDateSheet) { EmptyView() }
                    .hidden()
            )
            .listStyle(PlainListStyle())
            .navigationBarTitle("History", displayMode: .inline)
            .navigationBarItems(trailing:
                    NavigationLink(destination: NewDateView()) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                    })
        }
    }
    private func deleteDates(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
}

struct ListOfDateView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceContainer = PersistenceController.shared
        ListOfDateView()
            .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
    }
}


