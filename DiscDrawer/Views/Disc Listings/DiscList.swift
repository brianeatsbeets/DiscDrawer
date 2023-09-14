//
//  DiscList.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/12/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays discs in a list
struct DiscList: View {
    
    // MARK: - Properties
    
    // Environment
    
    // Managed object context
    @Environment(\.managedObjectContext) var moc
    
    // Basic
    
    let discs: FetchedResults<Disc>
    let types = ["Putter", "Midrange", "Fairway", "Driver"]
    
    // MARK: - Body view
    
    var body: some View {
        List {
            
            // Create sections for disc types
            ForEach(types, id: \.self) { type in
                
                // Only create a type section if it has matching discs
                if discs.contains(where: { $0.type == type }) {
                    Section(type) {
                        
                        // Display discs that match the section type
                        ForEach(discs) { disc in
                            if disc.type == type {
                                
                                // Link to AddEditDiscView
                                NavigationLink {
                                    AddEditDiscView(disc: disc)
                                } label: {
                                    DiscListItem(disc: disc)
                                }
                            }
                        }
                        .onDelete(perform: deleteDiscs)
                    }
                }
            }
        }
    }
    
    // MARK: - Functions
    
    // Delete specified discs
    func deleteDiscs(at offsets: IndexSet) {
        
        // Loop through each offset and delete the disc
        for offset in offsets {
            moc.delete(discs[offset])
        }

        // Save the context
        // TODO: Catch errors
        try? moc.save()
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays a single disc styled for a list
    struct DiscListItem: View {
        
        // MARK: - Properties
        
        let disc: Disc
        
        // MARK: - Body view
        
        var body: some View {
                
            // Main HStack
            HStack {
                
                // Disc image
                Color.red
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                
                // Disc info
                VStack(alignment: .leading) {
                    
                    // Disc name
                    Text(disc.wrappedName)
                        .font(.headline)
                    
                    // Disc manufacturer
                    if disc.manufacturer != "" {
                        Text(disc.wrappedManufacturer)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, 5)
            }
        }
    }
}

//struct DiscList_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscList()
//    }
//}
