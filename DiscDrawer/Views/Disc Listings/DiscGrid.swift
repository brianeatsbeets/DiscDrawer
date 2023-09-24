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
    
    @State private var showingDetailForDisc: Disc? = nil
    
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
                        Section(type) {
                            
                            // Display discs that match the section type
                            ForEach(discs) { disc in
                                if disc.type == type {
                                    
                                    // Link to AddEditDiscView
                                    Button {
                                        showingDetailForDisc = disc
                                    } label: {
                                        DiscGridItem(disc: disc)
                                    }
                                    .padding(.bottom)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(item: $showingDetailForDisc) { disc in

                // Manually add navigation view here to avoid adding a second navigation view when passing a disc
                NavigationView {
                    DiscDetailView(disc: disc)
                }
                .interactiveDismissDisabled()
            }
            
            Spacer()
        }
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays a single disc styled for a grid
    struct DiscGridItem: View {
        
        // MARK: - Properties
        
        @ObservedObject var disc: Disc
        
        // MARK: - Body view
        
        var body: some View {
            Group {
                
                // Main VStack
                VStack {
                    
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
                    .frame(height: 70)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Disc info
                    VStack(spacing: 3) {
                        
                        // Disc name
                        Text(disc.wrappedName)
                            .font(.headline)
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.8)
                        
                        // Disc manufacturer
                        if disc.manufacturer != "" {
                            Text(disc.wrappedManufacturer)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.1)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 1)
                                .background(
                                    Color.black
                                        .clipShape(Capsule())
                                )
                                .layoutPriority(1)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 10)
                .background(Color(white: 0.90))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(height: 150)
        }
    }
}

//struct DiscGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscGrid()
//    }
//}
