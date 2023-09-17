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
            
            ScrollView {
                
                // Main VStack
                VStack {
                    
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
                    DiscFlightNumbers(speed: discTemplate.wrappedSpeed,
                                      glide: discTemplate.wrappedGlide,
                                      turn: discTemplate.wrappedTurn,
                                      fade: discTemplate.wrappedFade,
                                      geo: geo)
                        .frame(width: geo.size.width * 0.9)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Other information
                    DiscOtherInfo(type: discTemplate.wrappedType,
                                  plastic: "Plastic",
                                  weight: "Weight",
                                  condition: "Condition",
                                  geo: geo)
                        .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // Enable scrolling on smaller screen sizes to maintain layout consistency
            .scrollDisabled(UIScreen.main.bounds.height >= 812)
        }
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays flight numbers for a Disc
    struct DiscFlightNumbers: View {
        
        // MARK: - Properties
        
        // State
        
        @State private var attributes = [(String, String, Color)]()
        
        // Basic
        
        let speed: String
        let glide: String
        let turn: String
        let fade: String
        
        let geo: GeometryProxy
        
        // MARK: - Initializers
        
        init(speed: String, glide: String, turn: String, fade: String, geo: GeometryProxy) {
            self.speed = speed
            self.glide = glide
            self.turn = turn
            self.fade = fade
            self.geo = geo
            
            _attributes = State(initialValue: [("Speed", speed, .green), ("Glide", glide, .yellow), ("Turn", turn, .pink), ("Fade", fade, .blue)])
        }
        
        // MARK: - Body view
        
        var body: some View {
            
            // Main HStack
            HStack {
                
                ForEach(attributes, id: \.0) { attribute in
                    
                    ZStack {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(attribute.2)
                            .aspectRatio(1.0, contentMode: .fit)
                        
                        // Text
                        VStack {
                            Text(attribute.1)
                                .font(.largeTitle.weight(.semibold))
                            Text(attribute.0)
                                .font(.headline)
                        }
                    }
                    .frame(minWidth: geo.size.width * 0.1)
                }
            }
        }
    }
    
    // This struct provides a view that displays additional disc information about a Disc
    struct DiscOtherInfo: View {
        
        // MARK: - Properties
        
        // State
        
        @State private var rowOneAttributes = [(String, String)]()
        @State private var rowTwoAttributes = [(String, String)]()
        @State private var attributeRows = [[(String, String)]]()
        
        // Basic
        
        let type: String
        let plastic: String?
        let weight: String?
        let condition: String?
        
        let geo: GeometryProxy
        
        // MARK: - Initializers
        
        init(type: String, plastic: String?, weight: String?, condition: String?, geo: GeometryProxy) {
            self.type = type
            self.plastic = plastic
            self.weight = weight
            self.condition = condition
            self.geo = geo
            
            _rowOneAttributes = State(initialValue: [("Type", type), ("Plastic", plastic ?? "")])
            _rowTwoAttributes = State(initialValue: [("Weight", weight ?? ""), ("Condition", condition ?? "")])
            _attributeRows = State(initialValue: [rowOneAttributes, rowTwoAttributes])
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
