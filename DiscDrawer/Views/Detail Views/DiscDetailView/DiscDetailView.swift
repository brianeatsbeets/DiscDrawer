//
//  DiscDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/14/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays information about a disc
struct DiscDetailView: View {

    // MARK: - Properties

    // Environment

    @Environment(\.dismiss) var dismiss

    // ObservedObject

    @ObservedObject var disc: Disc

    // Binding

    @Binding var discDetailToShow: Disc?

    // Basic

    let widthFactor = 0.85

    // MARK: - Body view

    var body: some View {

        GeometryReader { geo in

            ScrollView {

                // Main VStack
                VStack {

                    // Disc image
                    ZStack {

                        // Image
                        if let imageData = disc.imageData,
                           let discImage = UIImage(data: imageData) {
                            Image(uiImage: discImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .foregroundColor(.red)
                                .scaledToFit()
                        }

                        // Border
                        Circle()
                            .stroke(Color("DiscDetailImageBorder"), lineWidth: 3)
                    }
                    .frame(width: geo.size.height * 0.25)
                    .padding(.top, -30)

                    HStack {

                        // Spacer to mirror in bag stack
                        Spacer()
                            .frame(maxWidth: geo.size.width * 0.15)

                        // Disc name and manufacturer
                        VStack {
                            Text(disc.wrappedName)
                                .font(.largeTitle.bold())
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text(disc.wrappedManufacturer)
                                .font(.title3.bold())
                                .foregroundStyle(Color.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color(white: 0.25))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        // In bag
                        VStack {
                            Text("In bag")
                                .font(.callout).bold()
                            Image(systemName: disc.inBag ? "checkmark.circle" : "xmark.circle")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: geo.size.width * 0.15, alignment: .trailing)
                    }
                    .frame(width: geo.size.width * widthFactor)

                    Spacer()
                        .frame(height: geo.size.height * 0.05)

                    // Flight numbers
                    DiscDetailFlightNumbers(disc: disc, geo: geo)
                        .frame(width: geo.size.width * widthFactor)

                    Spacer()
                        .frame(height: geo.size.height * 0.05)

                    // Other information
                    DiscDetailOtherInfo(disc: disc, geo: geo)
                        .frame(width: geo.size.width * widthFactor, height: geo.size.width * widthFactor)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            AddEditDiscView(disc: disc, discDetailToShow: $discDetailToShow)
                        } label: {
                            Text("Edit")
                        }
                    }
                }
            }
            // Enable scrolling on smaller screen sizes to maintain layout consistency
            .scrollDisabled(UIScreen.main.bounds.height >= 812)
        }
    }
}
