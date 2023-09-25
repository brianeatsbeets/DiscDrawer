//
//  FilteredDiscView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/11/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a sorted and filtered listing of discs
struct FilteredDiscView: View {

    // MARK: - Properties

    // Fetch request

    // Uninitialized fetch request
    @FetchRequest var discs: FetchedResults<Disc>

    // Basic

    var viewMode: String

    // MARK: - Initializers

    // Provide values for view mode and sort descriptors
    init(viewMode: String, sortDescriptor: SortDescriptor<Disc>) {
        self.viewMode = viewMode
        _discs = FetchRequest<Disc>(sortDescriptors: [sortDescriptor])
    }

    // MARK: - Body view

    var body: some View {

        // Display listing variation based on view mode
        if viewMode == "list" {
            DiscList(discs: discs)
        } else {
            DiscGrid(discs: discs)
        }
    }
}
