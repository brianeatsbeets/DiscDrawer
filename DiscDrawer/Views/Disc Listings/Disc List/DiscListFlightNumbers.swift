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

//#Preview {
//    DiscListFlightNumbers()
//}
