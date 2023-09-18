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
                        .font(.headline.bold())
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .lineSpacing(-1)
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
                        .foregroundColor(.green.opacity(0.4))
                    
                    // Text
                    VStack {
                        Text("Type")
                            .font(.headline.bold())
                            .offset(x: 10, y: -10)
                            .opacity(0.65)
                    }
                }
                .overlay(
                    
                    // Field value
                    Text(type)
                        .font(.largeTitle.bold())
                        .opacity(0.65),
                    alignment: .center
                )
            }
        }
    }
    
    // This struct provides a view that displays additional disc information about a Disc
    struct DiscFlightNumbers: View {
        
        // MARK: - Properties
        
        let geo: GeometryProxy
        
        var rowOneAttributes: [(String, String)]
        var rowTwoAttributes: [(String, String)]
        var attributeRows: [[(String, String)]]
        
        let backgroundColor = Color.cyan.opacity(0.2)
        let foregroundOpacityFactor = 0.65
        
        // MARK: - Initializers
        
        init(discTemplate: DiscTemplate, geo: GeometryProxy) {
            self.geo = geo
            
            rowOneAttributes = [("Speed", discTemplate.wrappedSpeed), ("Glide", discTemplate.wrappedGlide)]
            rowTwoAttributes = [("Turn", discTemplate.wrappedTurn), ("Fade", discTemplate.wrappedFade)]
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
                                    .foregroundColor(backgroundColor)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                
                                // Field name
                                Text(attribute.0)
                                    .font(.headline)
                                    .opacity(foregroundOpacityFactor)
                                    .offset(x: 10, y: -10)
                            }
                            .overlay(
                                
                                // Field value
                                Text(attribute.1)
                                    .font(SwiftUI.Font.system(size: 50).bold())
                                    .opacity(foregroundOpacityFactor),
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
