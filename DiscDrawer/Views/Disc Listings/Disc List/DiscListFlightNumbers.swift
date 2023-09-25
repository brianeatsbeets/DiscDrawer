//
//  DiscListFlightNumbers.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays additional disc information about a Disc
struct DiscListFlightNumbers: View {

    // MARK: - Properties

    // Helper struct to contain disc attribute data
    struct Attribute {
        let label: String
        let value: String
        let color: Color
    }

    var rowOneAttributes: [Attribute]
    var rowTwoAttributes: [Attribute]
    var attributeRows: [[Attribute]]

    // MARK: - Initializers

    init(disc: Disc) {
        rowOneAttributes = [Attribute(label: "Speed", value: disc.speed.formatted(), color: .green), Attribute(label: "Glide", value: disc.glide.formatted(), color: .yellow)]
        rowTwoAttributes = [Attribute(label: "Turn", value: disc.turn.formatted(), color: .red), Attribute(label: "Fade", value: disc.fade.formatted(), color: .blue)]
        attributeRows = [rowOneAttributes, rowTwoAttributes]
    }

    // MARK: - Body view

    var body: some View {

        // 2x2 grid
        VStack(spacing: 7) {

            // Loop through each attribute row
            ForEach(attributeRows, id: \.first!.label) { row in

                // Row
                HStack {

                    // Loop through each attribute
                    ForEach(row, id: \.label) { attribute in

                        ZStack {

                            // Background
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(attribute.color, lineWidth: 2)
                                .background(
                                    attribute.color
                                        .brightness(0.3)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 5)
                                        )
                                )

                            // Field value
                            Text("\(attribute.label.first!)" + "\(attribute.value)")
                                .minimumScaleFactor(0.5)
                                .fontWeight(.heavy)
                                .foregroundColor(attribute.color)
                                .colorMultiply(Color(white: 0.5))
                                .padding(.horizontal, 3)
                        }
                    }
                }
            }
        }
    }
}
