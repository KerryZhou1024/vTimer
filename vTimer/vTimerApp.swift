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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
