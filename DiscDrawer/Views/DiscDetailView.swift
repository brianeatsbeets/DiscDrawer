//
//  DiscDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/14/23.
//

import CoreData
import SwiftUI

struct DiscDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var disc: Disc
    
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
                    Text(disc.wrappedName)
                        .font(.title.weight(.semibold))
                    Text(disc.wrappedManufacturer)
                        .font(.headline)
                }
                
                // Flight numbers
                FlightNumbers(disc: disc, geo: geo)
                    .frame(maxWidth: geo.size.width * 0.85)
                
                // Other information
                // Have frame be a 1:1 aspect ratio
                // Use passed spacing value
                // Have shape width be 90% and spacer width be 10%
                OtherInfo(disc: disc, geo: geo)
                    .frame(maxWidth: geo.size.width * 0.85, maxHeight: geo.size.height * 0.45)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditDiscView(disc: disc)) {
                        Text("Edit")
                    }
                    .buttonStyle(.automatic)
                }
            }
        }
    }
    
    // MARK: - Nested structs
    
    struct FlightNumbers: View {
        let disc: Disc
        let geo: GeometryProxy
        let shapeWidthFactor = 0.18
        
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
                        Text(disc.speed, format: .number)
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
                        Text(disc.glide, format: .number)
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
                        Text(disc.turn, format: .number)
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
                        Text(disc.fade, format: .number)
                            .font(.largeTitle.weight(.semibold))
                        Text("Fade")
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    struct OtherInfo: View {
        let disc: Disc
        let geo: GeometryProxy
        let shapeWidthFactor = 0.37
        
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
                        Text(disc.wrappedType)
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
                        Text(disc.wrappedPlastic)
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
                        Text("\(disc.weight)g")
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
                        Text(disc.wrappedCondition)
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
