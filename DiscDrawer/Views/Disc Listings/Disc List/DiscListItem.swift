//
//  DiscListItem.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a single disc styled for a list
struct DiscListItem: View {

    // MARK: - Properties

    // Environment

    @Environment(\.colorScheme) var colorScheme

    // Observed objects

    @ObservedObject var disc: Disc

    // Basic

    let frameHeight = 80.0
    var contentHeight: Double {
        frameHeight - 15
    }

    // MARK: - Body view

    var body: some View {

        // Main stack
        ZStack {

            // Background/border
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("DiscListItemBorder"), lineWidth: 3)
                .background(
                    Color.mint
                        .brightness(colorScheme == .light ? 0.8 : 0)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                )
                .frame(height: frameHeight)

            // Content stack
            HStack {

                // Disc info
                ZStack(alignment: .trailing) {

                    // Background
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(.mint, lineWidth: 2)
                        .background(
                            Color.mint
                                .brightness(0.45)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15)
                                )
                        )

                    // Text
                    VStack(alignment: .trailing) {
                        if disc.wrappedManufacturer != "N/A" {
                            Text(abbreviatedManufacturer())
                        }
                        if disc.wrappedPlastic != "N/A" {
                            Text(disc.wrappedPlastic)
                        }
                        if disc.weight > 0 {
                            Text("\(disc.weight)g")
                        }
                    }
                    .font(.system(size: 15).bold())
                    .minimumScaleFactor(0.5)
                    .lineSpacing(-1)
                    .foregroundColor(.cyan)
                    .colorMultiply(Color(white: 0.5))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                }
                .frame(maxWidth: .infinity, maxHeight: contentHeight)

                // Disc image/name
                ZStack {

                    // Disc image
                    ZStack {
                        if let imageData = disc.imageData,
                           let discImage = UIImage(data: imageData) {
                            Image(uiImage: discImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        } else {
                            Color.red
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                        }

                        Circle()
                            .stroke(.white, lineWidth: 3)
                    }
                    .frame(height: 95)

                    // Disc name
                    Text(disc.wrappedName)
                        .frame(width: 85, height: 20)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(
                            ZStack {
                                Capsule()
                                    .fill(.black)
                                Capsule()
                                    .stroke(.white, lineWidth: 3)
                            }
                        )
                        .offset(y: 35)
                }

                // Flight numbers
                DiscListFlightNumbers(disc: disc)
                    .frame(maxWidth: .infinity, maxHeight: contentHeight)
                    .padding(.horizontal, 8)

            }
            .padding(.horizontal, 10)
            .frame(height: frameHeight)
        }
    }

    // Helper function to abbreviate long manufacturer names
    func abbreviatedManufacturer() -> String {
        let components = disc.wrappedManufacturer.components(separatedBy: " ")
        if components.count >= 3 {
            let initials = components.map { "\($0.first ?? Character(""))" }
            return initials.reduce("") { $0 + $1 }
        } else {
            return disc.wrappedManufacturer
        }
    }
}

// Original layout

//    // This struct provides a view that displays a single disc styled for a list
//    struct DiscListItem: View {
//
//        // MARK: - Properties
//
//        @ObservedObject var disc: Disc
//
//        // MARK: - Body view
//
//        var body: some View {
//
//            // Main HStack
//            HStack {
//
//                // Disc image
//                Color.red
//                    .clipShape(Circle())
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 50)
//
//                // Disc info
//                VStack(alignment: .leading) {
//
//                    // Disc name
//                    Text(disc.wrappedName)
//                        .font(.headline)
//
//                    // Disc manufacturer
//                    if disc.manufacturer != "" {
//                        Text(disc.wrappedManufacturer)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                .padding(.leading, 5)
//            }
//        }
//    }
