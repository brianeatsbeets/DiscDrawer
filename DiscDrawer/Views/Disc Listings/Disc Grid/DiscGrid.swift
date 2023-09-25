//
//  DiscGrid.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/12/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays discs in a grid
struct DiscGrid: View {

    // MARK: - Properties

    // Environment

    // Managed object context
    @Environment(\.managedObjectContext) var moc

    // State

    @State private var discDetailToShow: Disc?

    // Basic

    let discs: FetchedResults<Disc>
    let types = ["Putter", "Midrange", "Fairway", "Driver"]

    // Grid layout
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    // MARK: - Body view

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {

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
                                        DiscGridItem(disc: disc)
                                    }
                                    .padding(.bottom)
                                }
                            }
                        } header: {
                            DiscCollectionHeader(type: type)
                        }
                    }
                }
            }
            .padding()
            .sheet(item: $discDetailToShow) { disc in

                // Manually add navigation view here to avoid adding a second navigation view when passing a disc
                NavigationView {
                    DiscDetailView(disc: disc, discDetailToShow: $discDetailToShow)
                }
                .interactiveDismissDisabled()
            }

            Spacer()
        }
    }
}

//struct DiscGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscGrid()
//    }
//}
