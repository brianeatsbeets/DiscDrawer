//
//  DiscDetailFlightNumbers.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays flight numbers for a Disc
struct DiscDetailFlightNumbers: View {

    // MARK: - Properties

    // ObservedObject

    @ObservedObject var disc: Disc

    // Basic

    let minWidthFactor = 0.1
    let backgroundOpacityFactor = 0.4

    // MARK: - Initializers

    init(disc: Disc, geo: GeometryProxy) {
        self.disc = disc
    }

    // MARK: - Body view

    var body: some View {

        // Main HStack
        HStack(spacing: 20) {

            // Speed
            ZStack(alignment: .bottom) {

                // Background
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.green, lineWidth: 3)
                    .background(
                        Color.green
                            .brightness(0.3)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    )
                    .aspectRatio(1.0, contentMode: .fit)

                // Text
                Text("Speed")
                    .font(.subheadline.bold())
                    .offset(y: -5)
                    .padding(.horizontal, 5)
                    .foregroundColor(.green)
                    .colorMultiply(Color(white: 0.5))
            }
            .overlay(

                // Field value
                Text(disc.speed.formatted())
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 7)
                    .foregroundColor(.green)
                    .colorMultiply(Color(white: 0.5))
                    .offset(y: -8),
                alignment: .center
            )

            // Glide
            ZStack(alignment: .bottom) {

                // Background
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.yellow, lineWidth: 3)
                    .background(
                        Color.yellow
                            .brightness(0.3)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    )
                    .aspectRatio(1.0, contentMode: .fit)

                // Text
                Text("Glide")
                    .font(.subheadline.bold())
                    .offset(y: -5)
                    .padding(.horizontal, 5)
                    .foregroundColor(.yellow)
                    .colorMultiply(Color(white: 0.5))
            }
            .overlay(

                // Field value
                Text(disc.glide.formatted())
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 7)
                    .foregroundColor(.yellow)
                    .colorMultiply(Color(white: 0.5))
                    .offset(y: -8),
                alignment: .center
            )

            // Turn
            ZStack(alignment: .bottom) {

                // Background
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.pink, lineWidth: 3)
                    .background(
                        Color.pink
                            .brightness(0.3)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    )
                    .aspectRatio(1.0, contentMode: .fit)

                // Text
                Text("Turn")
                    .font(.subheadline.bold())
                    .offset(y: -5)
                    .padding(.horizontal, 5)
                    .foregroundColor(.pink)
                    .colorMultiply(Color(white: 0.5))
            }
            .overlay(

                // Field value
                Text(disc.turn.formatted())
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 7)
                    .foregroundColor(.pink)
                    .colorMultiply(Color(white: 0.5))
                    .offset(y: -8),
                alignment: .center
            )

            // Fade
            ZStack(alignment: .bottom) {

                // Background
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.blue, lineWidth: 3)
                    .background(
                        Color.blue
                            .brightness(0.3)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    )
                    .aspectRatio(1.0, contentMode: .fit)

                // Text
                Text("Fade")
                    .font(.subheadline.bold())
                    .offset(y: -5)
                    .padding(.horizontal, 5)
                    .foregroundColor(.indigo)
                    .colorMultiply(Color(white: 0.5))
            }
            .overlay(

                // Field value
                Text(disc.fade.formatted())
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 7)
                    .foregroundColor(.indigo)
                    .colorMultiply(Color(white: 0.5))
                    .offset(y: -8),
                alignment: .center
            )
        }
    }
}
