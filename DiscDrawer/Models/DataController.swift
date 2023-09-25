//
//  DataController.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

// MARK: - Imported libraries

import CoreData

// MARK: - Main class

// This class implements a controller for a Core Data container
class DataController: ObservableObject {

    // MARK: - Properties

    // Core Data container
    let container = NSPersistentContainer(name: "DiscDrawer")

    // Init access to data
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
