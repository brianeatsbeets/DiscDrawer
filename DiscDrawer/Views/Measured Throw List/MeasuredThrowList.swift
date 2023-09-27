//
//  MeasuredThrowList.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays measured throws in a list
struct MeasuredThrowList: View {
    
    // MARK: - Properties

    // Environment

    // Managed object context
    @Environment(\.managedObjectContext) var moc
    
    // Fetch request
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.distance, order: .reverse)]) var measuredThrows: FetchedResults<MeasuredThrow>
    
    // State
    
    @State private var showingSelectDiscView = false
    
    // MARK: - Body view
    
    var body: some View {
        List {
            ForEach(measuredThrows, id: \.self) { measuredThrow in
                MeasuredThrowListItem(measuredThrow: measuredThrow)
            }
            .onDelete(perform: deleteThrows)
        }
        .navigationTitle("Measured Throws")
        .toolbar {
            
            // Measure new throw button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSelectDiscView.toggle()
                } label: {
                    Label("Measure Throw", systemImage: "plus")
                }
            }
        }
        .fullScreenCover(isPresented: $showingSelectDiscView) {
            NavigationView {
                SelectDiscView(showingSelectDiscView: $showingSelectDiscView)
            }
        }
    }
    
    // MARK: - Functions

    // Delete specified throws
    func deleteThrows(at offsets: IndexSet) {

        // Loop through each offset and delete the throw
        for offset in offsets {
            moc.delete(measuredThrows[offset])
        }

        // Save the context
        // TODO: Catch errors
        try? moc.save()
    }
}
