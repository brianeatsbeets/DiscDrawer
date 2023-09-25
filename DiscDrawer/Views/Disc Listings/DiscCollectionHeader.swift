//
//  DiscCollectionHeader.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a header view for a disc list or grid
struct DiscCollectionHeader: View {

    // MARK: - Properties

    let type: String

    // MARK: - Body view

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Text(type)
                .font(.title2.bold())
                .foregroundColor(.accentColor)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(
                    Color("DiscListSectionHeader")
                        .clipShape(
                            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 0, bottomTrailing: 0, topTrailing: 8))
                        )
                )

            Rectangle()
                .fill(Color("DiscListSectionHeader"))
                .frame(height: 3)
        }
    }
}
