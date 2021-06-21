//
//  vTimerApp.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/19/21.
//

import SwiftUI

@main
struct vTimerApp: App {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabView{
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Current Timer")
                    }
                
                
                PastActivities()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemName: "note.text")
                        Text("Past Activities")
                    }
            }
            
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
    
}
