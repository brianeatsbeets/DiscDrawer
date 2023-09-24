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
    
    @State private var showingDetailForDisc: Disc? = nil
    
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
                                    showingDetailForDisc = disc
                                } label: {
                                    DiscListItem(disc: disc)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .onDelete(perform: deleteDiscs)
                    } header: {
                        
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
            }
        }
        .listStyle(.plain)
        .sheet(item: $showingDetailForDisc) { disc in

            // Manually add navigation view here to avoid adding a second navigation view when passing a disc
            NavigationView {
                DiscDetailView(disc: disc)
            }
            .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Functions
    
    // Delete specified discs
    func deleteDiscs(at offsets: IndexSet) {
        
        // Loop through each offset and delete the disc
        for offset in offsets {
            moc.delete(discs[offset])
        }

        // Save the context
        // TODO: Catch errors
        try? moc.save()
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays a single disc styled for a list
    struct DiscListItem: View {
        
        // Environment
        
        @Environment(\.colorScheme) var colorScheme
        
        // MARK: - Properties
        
        @ObservedObject var disc: Disc
        
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
                    DiscFlightNumbers(disc: disc)
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
        
        // MARK: - Nested structs
        
        // This struct provides a view that displays additional disc information about a Disc
        struct DiscFlightNumbers: View {
            
            // MARK: - Properties
            
            var rowOneAttributes: [(String, String, Color)]
            var rowTwoAttributes: [(String, String, Color)]
            var attributeRows: [[(String, String, Color)]]
            
            // MARK: - Initializers
            
            init(disc: Disc) {
                rowOneAttributes = [("Speed", disc.speed.formatted(), .green), ("Glide", disc.glide.formatted(), .yellow)]
                rowTwoAttributes = [("Turn", disc.turn.formatted(), .red), ("Fade", disc.fade.formatted(), .blue)]
                attributeRows = [rowOneAttributes, rowTwoAttributes]
            }
            
            // MARK: - Body view
            
            var body: some View {
                    
                // 2x2 grid
                VStack(spacing: 7) {
                    
                    // Loop through each attribute row
                    ForEach(attributeRows, id: \.first!.0) { row in
                        
                        // Row
                        HStack {
                            
                            // Loop through each attribute
                            ForEach(row, id: \.0) { attribute in
                                
                                ZStack {
                                    
                                    // Background
                                    RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(attribute.2, lineWidth: 2)
                                        .background(
                                            attribute.2
                                                .brightness(0.3)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 5)
                                                )
                                        )
                                    
                                    // Field value
                                    Text("\(attribute.0.first!)" + "\(attribute.1)")
                                        .minimumScaleFactor(0.5)
                                        .fontWeight(.heavy)
                                        .foregroundColor(attribute.2)
                                        .colorMultiply(Color(white: 0.5))
                                        .padding(.horizontal, 3)
                                }
                            }
                        }
                    }
                }
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
}

//struct DiscList_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscList()
//    }
//}
