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

    // State

    @State private var discDetailToShow: Disc?

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
                    Section {

                        // Display discs that match the section type
                        ForEach(discs) { disc in
                            if disc.type == type {

                                // Link to AddEditDiscView
                                Button {
                                    discDetailToShow = disc
                                } label: {
                                    DiscListItem(disc: disc)
                                }
                                .listRowSeparator(.hidden)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deleteDisc(disc)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        disc.inBag.toggle()
                                        try? moc.save()
                                    } label: {
                                        Label(disc.inBag ? "Remove from Bag" : "Add to Bag", systemImage: disc.inBag ? "bag.fill.badge.minus" : "bag.fill.badge.plus")
                                    }
                                    .tint(disc.inBag ? .orange : .blue)
                                }
                            }
                        }
                    } header: {
                        DiscCollectionHeader(type: type)
                    }
                }
            }
        }
        .listStyle(.plain)
        .fullScreenCover(item: $discDetailToShow) { disc in

            // Manually add navigation view here to avoid adding a second navigation view when passing a disc
            NavigationView {
                DiscDetailView(disc: disc, discDetailToShow: $discDetailToShow)
            }
            .interactiveDismissDisabled()
        }
    }

    // MARK: - Functions
    
    // Delete specified disc
    func deleteDisc(_ disc: Disc) {
        moc.delete(disc)
        
        // Save the context
        // TODO: Catch errors
        try? moc.save()
    }
}
