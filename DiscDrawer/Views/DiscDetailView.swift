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
                    .frame(width: geo.size.width * 0.4)
                    .padding(.top, -50)
                
                // Disc name and manufacturer
                VStack {
                    Text(name)
                        .font(.title.weight(.semibold))
                    Text(manufacturer)
                        .font(.headline)
                }
                
                // Flight numbers
                FlightNumbers(speed: speed, glide: glide, turn: turn, fade: fade, geo: geo)
                    .frame(maxWidth: geo.size.width * 0.85)
                
                // Other information
                // Have frame be a 1:1 aspect ratio
                // Use passed spacing value
                // Have shape width be 90% and spacer width be 10%
                OtherInfo(type: type, plastic: plastic, weight: weight, condition: condition, geo: geo)
                    .frame(maxWidth: geo.size.width * 0.85, maxHeight: geo.size.height * 0.45)
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
    
    // TODO: See if we can consolidate this with a ForEach (maybe use an array of tuples [("Speed", speed), ("Glide", glide), etc.])
    // This struct provides a view that displays flight numbers
    struct FlightNumbers: View {
        
        // MARK: - Properties
        
        let speed: String
        let glide: String
        let turn: String
        let fade: String
        
        let geo: GeometryProxy
        let shapeWidthFactor = 0.18
        
        // MARK: - Body view
        
        var body: some View {
            HStack {
                
                // Speed
                ZStack {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.green)
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: geo.size.width * shapeWidthFactor)
                    
                    // Text
                    VStack {
                        Text(speed)
                            .font(.largeTitle.weight(.semibold))
                        Text("Speed")
                            .font(.headline)
                    }
                }
                
                Spacer()
                
                // Glide
                ZStack {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.yellow)
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: geo.size.width * shapeWidthFactor)
                    
                    // Text
                    VStack {
                        Text(glide)
                            .font(.largeTitle.weight(.semibold))
                        Text("Glide")
                            .font(.headline)
                    }
                }
                
                Spacer()
                
                // Turn
                ZStack {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.pink)
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: geo.size.width * shapeWidthFactor)
                    
                    // Text
                    VStack {
                        Text(turn)
                            .font(.largeTitle.weight(.semibold))
                        Text("Turn")
                            .font(.headline)
                    }
                }
                
                Spacer()
                
                // Fade
                ZStack {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.blue)
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: geo.size.width * shapeWidthFactor)
                    
                    // Text
                    VStack {
                        Text(fade)
                            .font(.largeTitle.weight(.semibold))
                        Text("Fade")
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    // TODO: See if we can consolidate this with a ForEach (maybe use an array of tuples [("Type", type), ("Plastic", plastic), etc.])
    // This struct provides a view that displays additional disc information
    struct OtherInfo: View {
        
        // MARK: - Properties
        
        let type: String
        let plastic: String?
        let weight: String?
        let condition: String?
        
        let geo: GeometryProxy
        let shapeWidthFactor = 0.37
        
        // MARK: - Body view
        
        var body: some View {
                
            // 2x2 grid
            VStack {
                
                // Row 1
                HStack {
                    
                    // Type
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.blue)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: geo.size.width * shapeWidthFactor)
                        
                        // Field name
                        Text("Type")
                            .font(.headline)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(type)
                            .font(.largeTitle.weight(.semibold)),
                        alignment: .center
                    )
                    
                    Spacer()
                    
                    // Plastic
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.blue)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: geo.size.width * shapeWidthFactor)
                        
                        // Field name
                        Text("Plastic")
                            .font(.headline)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(plastic ?? "Not specified")
                            .font(.largeTitle.weight(.semibold)),
                        alignment: .center
                    )
                }
                
                Spacer()
                
                // Row 2
                HStack {
                    
                    // Weight
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.blue)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: geo.size.width * shapeWidthFactor)
                        
                        // Field name
                        Text("Weight")
                            .font(.headline)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(weight ?? "Not specified")
                            .font(.largeTitle.weight(.semibold)),
                        alignment: .center
                    )
                    
                    Spacer()
                    
                    // Condition
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.blue)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: geo.size.width * shapeWidthFactor)
                        
                        // Field name
                        Text("Condition")
                            .font(.headline)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(condition ?? "Not specified")
                            .font(.largeTitle.weight(.semibold)),
                        alignment: .center
                    )
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
