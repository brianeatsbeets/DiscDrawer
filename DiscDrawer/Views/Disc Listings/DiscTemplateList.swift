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
            ForEach(discTemplates) { discTemplate in
                NavigationLink {

                    // Show disc details or edit view depending on context
                    if showingAddView != nil {
                        AddEditDiscView(discTemplate: discTemplate, showingAddView: showingAddView)
                    } else {
                        DiscTemplateDetailView(discTemplate: discTemplate)
                    }
                } label: {
                    DiscTemplateItem(disc: discTemplate)
                }
            }
        }
        .navigationTitle(showingAddView != nil ? "Select a disc" : "Disc Finder")
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Disc name")
        .autocorrectionDisabled(true)
        .onChange(of: searchQuery, initial: false) { _, newValue  in
            discTemplates.nsPredicate = searchPredicate(query: newValue)
        }
        .toolbar {

            // Display toolbar navigation buttons only if we're adding a disc
            if showingAddView != nil {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingAddView?.wrappedValue = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddEditDiscView(showingAddView: showingAddView)
                    } label: {
                        Text("Manually Create")
                    }
                }
            }
        }
    }

    // MARK: - Functions

    func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty {
            return nil
        } else {
            let partOne = NSPredicate(format: "name BEGINSWITH[c] %@", query)
            let partTwo = NSPredicate(format: "manufacturer BEGINSWITH[c] %@", query)
            return NSCompoundPredicate(orPredicateWithSubpredicates: [partOne, partTwo])
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
