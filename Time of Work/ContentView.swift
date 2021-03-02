//
//  ContentView.swift
//  Time of Work
//
//  Created by Robert Adamczyk on 27.11.20.
//

import SwiftUI
import PartialSheet

enum MyViews {
    case menu, datehisotry, mytime, settings
    
}

struct ContentView: View {
    @State private var push: MyViews = .menu

    var body: some View {
        
        VStack {
            
            if push == MyViews.menu {
                MenuView()
            }

            if push == MyViews.datehisotry {
                ListOfDateView()
            }
            
            if push == MyViews.mytime {
                MyTimeView()
            }
            
            if push == MyViews.settings {
                SettingsView()
            }
            
        }
        .padding(.bottom, 45)
        .addPartialSheet()
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack(alignment: .center, spacing: 60){
                    Button(action: {
                        push = MyViews.menu
                    }){
                        VStack{
                            Image(systemName: push == MyViews.menu ? "person.fill" : "person")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(push == MyViews.menu ? .blue : .gray)
                            Text("Start")
                                .font(.system(size: 10))
                        }
                    }
                    Button(action: {
                        push = MyViews.datehisotry
                    }){
                        VStack{
                            Image(systemName: push == MyViews.datehisotry ? "calendar.circle.fill" : "calendar.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(push == MyViews.datehisotry ? .blue : .gray)
                            Text("History")
                                .font(.system(size: 10))
                        }
                    }
                    Button(action: {
                        push = MyViews.mytime
                    }){
                        VStack{
                            Image(systemName: push == MyViews.mytime ? "clock.fill" : "clock")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(push == MyViews.mytime ? .blue : .gray)
                            Text("MyTime")
                                .font(.system(size: 10))
                        }
                    }
                    Button(action: {
                        push = MyViews.settings
                    }){
                        VStack{
                            Image(systemName: push == MyViews.settings ? "gearshape.fill" : "gearshape")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(push == MyViews.settings ? .blue : .gray)
                            Text("Settings")
                                .font(.system(size: 10))
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let persistenceContainer = PersistenceController.shared
        ContentView()
            .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
            .environmentObject(ProjectEnvironment())
    }
}
