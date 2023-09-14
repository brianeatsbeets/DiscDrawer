//
//  DiscTemplateList.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/13/23.
//

// TODO: Add more info to disc template item view

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
    
    // Bindings
    
    // Optional property used to dismiss multiple sheets at once
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
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays a single disc template styled for a list
    struct DiscTemplateItem: View {
        
        // MARK: - Properties
        
        var disc: DiscTemplate
        
        // MARK: - Body view
        
        var body: some View {
            Text(disc.wrappedName)
        }
    }
}

//struct DiscTemplateList_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscTemplateList()
//    }
//}
