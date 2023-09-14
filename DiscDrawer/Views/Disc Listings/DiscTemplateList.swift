//
//  DiscTemplateList.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/13/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a sorted list of disc templates
struct DiscTemplateList: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.managedObjectContext) var moc
    
    // Fetch requests
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var discTemplates: FetchedResults<DiscTemplate>
    
    // State
    
    @State private var searchQuery = ""
    
    // Bindings
    
    // Optional binding used to dismiss multiple sheets at once
    var showingAddView: Binding<Bool>?
    
    // MARK: - Body view
    
    var body: some View {
        List {
            ForEach(discTemplates) { disc in
                NavigationLink {
                    AddEditDiscView(discTemplate: disc, showingAddView: showingAddView)
                } label: {
                    DiscTemplateItem(disc: disc)
                }
            }
        }
        .navigationTitle("Select a Disc")
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Disc name")
        .autocorrectionDisabled(true) 
        .onChange(of: searchQuery) { newValue in
            discTemplates.nsPredicate = searchPredicate(query: newValue)
        }
    }
    
    // MARK: - Functions
    
    func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty {
            return nil
        } else {
            return NSPredicate(format: "name BEGINSWITH[cd] %@", query)
        }
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays a single disc template styled for a list
    struct DiscTemplateItem: View {
        
        // MARK: - Properties
        
        var disc: DiscTemplate
        
        // MARK: - Body view
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(disc.wrappedName)
                        .font(.headline)
                    Text(disc.wrappedManufacturer)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(disc.wrappedType)
                        .font(.headline)
                    Text("\(disc.wrappedSpeed) | \(disc.wrappedGlide) | \(disc.wrappedTurn) | \(disc.wrappedFade)")
                }
            }
        }
    }
}

//struct DiscTemplateList_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscTemplateList()
//    }
//}
