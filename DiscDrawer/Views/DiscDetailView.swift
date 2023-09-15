//
//  DiscDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/14/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays information about a disc or disc template
struct DiscDetailView: View {
    
    // MARK: - Properties
    
    // Environment
    @Environment(\.dismiss) var dismiss
    
    // ObservedObject
    
    var disc: ObservedObject<Disc>?
    
    // Standard
    
    let discTemplate: DiscTemplate?
    
    let name: String
    let manufacturer: String
    let type: String
    let speed: String
    let glide: String
    let turn: String
    let fade: String
    
    // These properties won't be used if we're passed a disc template
    let plastic: String?
    let weight: String?
    let condition: String?
    
    // MARK: - Initializers
    
    // Init with disc
    init(disc: Disc) {
        self.disc = ObservedObject(initialValue: disc)
        discTemplate = nil
        
        name = disc.wrappedName
        type = disc.wrappedType
        manufacturer = disc.wrappedManufacturer
        speed = String(disc.speed)
        glide = String(disc.glide)
        turn = String(disc.turn)
        fade = String(disc.fade)
        
        plastic = disc.wrappedPlastic
        weight = String(disc.weight)
        condition = disc.wrappedCondition
    }

    // Init with disc template
    init(discTemplate: DiscTemplate) {
        self.discTemplate = discTemplate
        disc = nil
        
        name = discTemplate.wrappedName
        type = discTemplate.wrappedType
        manufacturer = discTemplate.wrappedManufacturer
        speed = discTemplate.wrappedSpeed
        glide = discTemplate.wrappedGlide
        turn = discTemplate.wrappedTurn
        fade = discTemplate.wrappedFade
        
        plastic = nil
        weight = nil
        condition = nil
    }
    
    // MARK: - Body view
    
    var body: some View {
        
        GeometryReader { geo in
            
            // Main VStack
            VStack(spacing: 20) {
                
                // Disc image
                Circle()
                    .foregroundColor(.red)
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.45)
                    .padding(.top, -50)
                
                // Disc name and manufacturer
                VStack {
                    Text(name)
                        .font(.title.weight(.semibold))
                    Text(manufacturer)
                        .font(.headline)
                }
                
                // Flight numbers
                DiscFlightNumbers(speed: speed, glide: glide, turn: turn, fade: fade, geo: geo)
                    .frame(width: geo.size.width * 0.9)
                
                // Other information
                DiscOtherInfo(type: type, plastic: plastic, weight: weight, condition: condition, geo: geo)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: geo.size.width * 0.9)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                
                // If we were passed a Disc, display these toolbar items
                if disc != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddEditDiscView(disc: disc!.wrappedValue)) {
                            Text("Edit")
                        }
                        .buttonStyle(.automatic)
                    }
                }
            }
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
        let shapeWidthFactor = 0.2
        
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
                            .frame(width: geo.size.width * shapeWidthFactor)
                        
                        // Text
                        VStack {
                            Text(attribute.1)
                                .font(.largeTitle.weight(.semibold))
                            Text(attribute.0)
                                .font(.headline)
                        }
                    }
                    
                    if attribute != attributes.last! {
                        Spacer()
                    }
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
                
                // TODO: See if there is a better identifier to use here; it may not really matter in the end because the data is all manually constructed
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
                            
                            if attribute != row.last! {
                                //Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct DiscDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscDetailView(disc: disc)
//    }
//}
