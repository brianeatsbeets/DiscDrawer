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
                    Section(type) {
                        
                        // Display discs that match the section type
                        ForEach(discs) { disc in
                            if disc.type ==  type {
                                
                                // Link to AddEditDiscView
                                NavigationLink {
                                    AddEditDiscView(disc: disc)
                                } label: {
                                    DiscGridItem(disc: disc)
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays a single disc styled for a grid
    struct DiscGridItem: View {
        
        // MARK: - Properties
        
        let disc: Disc
        
        // MARK: - Body view
        
        var body: some View {
            Group {
                
                // Main VStack
                VStack {
                    
                    // Disc image
                    Color.red
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
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
