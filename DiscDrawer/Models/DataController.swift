//
//  DataController.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    // Create the Core Data container
    let container = NSPersistentContainer(name: "DiscDrawer")
    
    // Initializer to load access to data
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
