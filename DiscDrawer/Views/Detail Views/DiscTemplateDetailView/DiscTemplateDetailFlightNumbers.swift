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
    
    let geo: GeometryProxy
    
    var rowOneAttributes: [(String, String, Color)]
    var rowTwoAttributes: [(String, String, Color)]
    var attributeRows: [[(String, String, Color)]]
    
    let backgroundOpacityFactor = 0.4
    
    // MARK: - Initializers
    
    init(discTemplate: DiscTemplate, geo: GeometryProxy) {
        self.geo = geo
        
        rowOneAttributes = [("Speed", discTemplate.wrappedSpeed, .green), ("Glide", discTemplate.wrappedGlide, .yellow)]
        rowTwoAttributes = [("Turn", discTemplate.wrappedTurn, .red), ("Fade", discTemplate.wrappedFade, .indigo)]
        attributeRows = [rowOneAttributes, rowTwoAttributes]
    }
    
    // MARK: - Body view
    
    var body: some View {
            
        // 2x2 grid
        VStack(spacing: geo.size.width * 0.05) {
            
            // Loop through each attribute row
            ForEach(attributeRows, id: \.first!.0) { row in
                
                // Row
                HStack(spacing: geo.size.width * 0.05) {
                    
                    // Loop through each attribute
                    ForEach(row, id: \.0) { attribute in
                        
                        ZStack(alignment: .bottomLeading) {
                            
                            // Background
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(attribute.2, lineWidth: 3)
                                .background(
                                    attribute.2
                                        .brightness(0.3)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 20)
                                        )
                                )
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                            
                            // Field name
                            Text(attribute.0)
                                .font(.headline)
                                .foregroundColor(attribute.2)
                                .colorMultiply(Color(white: 0.5))
                                .offset(x: 10, y: -10)
                        }
                        .overlay(
                            
                            // Field value
                            Text(attribute.1)
                                .font(SwiftUI.Font.system(size: 50).bold())
                                .foregroundColor(attribute.2)
                                .colorMultiply(Color(white: 0.5)),
                            alignment: .center
                        )
                    }
                }
            }
        }
    }
}

//#Preview {
//    DiscTemplateDetailFlightNumbers()
//}
