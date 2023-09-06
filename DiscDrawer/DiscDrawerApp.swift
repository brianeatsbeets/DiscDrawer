//
//  DiscDrawerApp.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

import SwiftUI

@main
struct DiscDrawerApp: App {
    
    // Create our Core Data data controller object
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
