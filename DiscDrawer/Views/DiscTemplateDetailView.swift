//
//  DiscTemplateDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/17/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays information about a disc template
struct DiscTemplateDetailView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.dismiss) var dismiss
    
    // Basic
    
    let discTemplate: DiscTemplate
    let widthFactor = 0.85
    
    // MARK: - Body view
    
    var body: some View {
        
        GeometryReader { geo in
                
            // Main VStack
            VStack {
                
                Spacer()
                
                // Disc name and manufacturer
                VStack {
                    Text(discTemplate.wrappedName)
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(discTemplate.wrappedManufacturer)
                        .font(.title3.bold())
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color(white: 0.25))
                }
                
                Spacer()
                    .frame(height: 20)
                
                // Disc type
                DiscType(type: discTemplate.wrappedType)
                .frame(width: geo.size.width * widthFactor, height: geo.size.height * 0.12)
                
                Spacer()
                    .frame(height: 20)
                
                // Flight numbers
                DiscFlightNumbers(discTemplate: discTemplate, geo: geo)
                    .frame(width: geo.size.width * widthFactor, height: geo.size.width * widthFactor)
                    .padding(.bottom)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays flight numbers for a Disc
    struct DiscType: View {
        
        // MARK: - Properties
        
        let type: String
        
        // MARK: - Body view
        
        var body: some View {
            
            // Main HStack
            HStack {
                    
                ZStack(alignment: .bottomLeading) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.cyan, lineWidth: 3)
                        .background(
                            Color.cyan
                                .brightness(0.3)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 20)
                                )
                        )
                    
                    // Text
                    VStack {
                        Text("Type")
                            .font(.headline.bold())
                            .offset(x: 10, y: -10)
                            .foregroundColor(.cyan)
                            .colorMultiply(Color(white: 0.5))
                    }
                }
                .overlay(
                    
                    // Field value
                    Text(type)
                        .font(.largeTitle.bold())
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5)),
                    alignment: .center
                )
            }
        }
    }
    
    // This struct provides a view that displays additional disc information about a Disc
    struct DiscFlightNumbers: View {
        
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
}

//struct DiscTemplateDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscTemplateDetailView(disc: disc)
//    }
//}
