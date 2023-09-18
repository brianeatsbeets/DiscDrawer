//
//  DiscTemplateDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/17/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays information about a disc or disc template
struct DiscTemplateDetailView: View {
    
    // MARK: - Properties
    
    // Environment
    @Environment(\.dismiss) var dismiss
    
    var discTemplate: DiscTemplate
    
    // MARK: - Body view
    
    var body: some View {
        
        GeometryReader { geo in
                
            // Main VStack
            VStack {
                
                Spacer()
                
                // Disc name and manufacturer
                VStack {
                    Text(discTemplate.wrappedName)
                        .font(.title.weight(.semibold))
                    Text(discTemplate.wrappedManufacturer)
                        .font(.headline)
                }
                
                Spacer()
                    .frame(height: 20)
                
                // Flight numbers
                DiscType(type: discTemplate.wrappedType,
                                  geo: geo)
                .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.12)
                
                Spacer()
                    .frame(height: 20)
                
                // Other information
                DiscFlightNumbers(speed: discTemplate.wrappedSpeed,
                              glide: discTemplate.wrappedGlide,
                              turn: discTemplate.wrappedTurn,
                              fade: discTemplate.wrappedFade,
                              geo: geo)
                    .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
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
        let geo: GeometryProxy
        
        // MARK: - Initializers
        
        init(type: String, geo: GeometryProxy) {
            self.type = type
            self.geo = geo
        }
        
        // MARK: - Body view
        
        var body: some View {
            
            // Main HStack
            HStack {
                    
                ZStack(alignment: .bottomLeading) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.green)
                    
                    // Text
                    VStack {
                        Text("Type")
                            .font(.headline)
                            .offset(x: 10, y: -10)
                    }
                }
                .overlay(
                    // Field value
                    Text(type)
                        .font(.largeTitle.weight(.semibold)),
                    alignment: .center
                )
            }
        }
    }
    
    // This struct provides a view that displays additional disc information about a Disc
    struct DiscFlightNumbers: View {
        
        // MARK: - Properties
        
        let speed: String
        let glide: String
        let turn: String
        let fade: String
        
        let geo: GeometryProxy
        
        var rowOneAttributes: [(String, String)]
        var rowTwoAttributes: [(String, String)]
        var attributeRows: [[(String, String)]]
        
        // MARK: - Initializers
        
        init(speed: String, glide: String, turn: String, fade: String, geo: GeometryProxy) {
            self.speed = speed
            self.glide = glide
            self.turn = turn
            self.fade = fade
            self.geo = geo
            
            rowOneAttributes = [("Speed", speed), ("Glide", glide)]
            rowTwoAttributes = [("Turn", turn), ("Fade", fade)]
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
                                    .foregroundColor(.blue)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                
                                // Field name
                                Text(attribute.0)
                                    .font(.headline)
                                    .offset(x: 10, y: -10)
                            }
                            .overlay(
                                // Field value
                                Text(attribute.1)
                                    .font(.largeTitle.weight(.semibold)),
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
