//
//  DiscTemplateDetailFlightNumbers.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays additional disc information about a Disc
struct DiscTemplateDetailFlightNumbers: View {

    // MARK: - Properties

    // Helper struct to contain disc attribute data
    struct Attribute {
        let label: String
        let value: String
        let color: Color
    }

    let geo: GeometryProxy

    var rowOneAttributes: [Attribute]
    var rowTwoAttributes: [Attribute]
    var attributeRows: [[Attribute]]

    let backgroundOpacityFactor = 0.4

    // MARK: - Initializers

    init(discTemplate: DiscTemplate, geo: GeometryProxy) {
        self.geo = geo
        rowOneAttributes = [Attribute(label: "Speed", value: discTemplate.wrappedSpeed, color: .green), Attribute(label: "Glide", value: discTemplate.wrappedGlide, color: .yellow)]
        rowTwoAttributes = [Attribute(label: "Turn", value: discTemplate.wrappedTurn, color: .red), Attribute(label: "Fade", value: discTemplate.wrappedFade, color: .blue)]
        attributeRows = [rowOneAttributes, rowTwoAttributes]
    }

    // MARK: - Body view

    var body: some View {

        // 2x2 grid
        VStack(spacing: geo.size.width * 0.05) {

            // Loop through each attribute row
            ForEach(attributeRows, id: \.first!.label) { row in

                // Row
                HStack(spacing: geo.size.width * 0.05) {

                    // Loop through each attribute
                    ForEach(row, id: \.label) { attribute in

                        ZStack(alignment: .bottomLeading) {

                            // Background
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(attribute.color, lineWidth: 3)
                                .background(
                                    attribute.color
                                        .brightness(0.3)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 20)
                                        )
                                )
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(maxWidth: .infinity)

                            // Field name
                            Text(attribute.label)
                                .font(.headline)
                                .foregroundColor(attribute.color)
                                .colorMultiply(Color(white: 0.5))
                                .offset(x: 10, y: -10)
                        }
                        .overlay(

                            // Field value
                            Text(attribute.value)
                                .font(SwiftUI.Font.system(size: 50).bold())
                                .foregroundColor(attribute.color)
                                .colorMultiply(Color(white: 0.5)),
                            alignment: .center
                        )
                    }
                }
            }
        }
    }
}
