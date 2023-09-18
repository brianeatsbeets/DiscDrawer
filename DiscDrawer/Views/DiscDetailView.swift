//
//  DiscDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/14/23.
//

// TODO: Select specific colors instead of just relying on opacity

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays information about a disc or disc template
struct DiscDetailView: View {
    
    // MARK: - Properties
    
    // Environment
    @Environment(\.dismiss) var dismiss
    
    // ObservedObject
    
    @ObservedObject var disc: Disc
    
    // Basic
    
    let widthFactor = 0.85
    
    // MARK: - Body view
    
    var body: some View {
        
        GeometryReader { geo in
            
            ScrollView {
                
                // Main VStack
                VStack {
                    
                    // Disc image
                    Circle()
                        .foregroundColor(.red)
                        .scaledToFit()
                        .frame(width: geo.size.height * 0.25)
                        .padding(.top, -30)
                    
                    HStack {
                        
                        // Spacer to mirror in bag stack
                        Spacer()
                            .frame(maxWidth: geo.size.width * 0.15)
                        
                        // Disc name and manufacturer
                        VStack {
                            Text(disc.wrappedName)
                                .font(.largeTitle.bold())
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text(disc.wrappedManufacturer)
                                .font(.headline.bold())
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .lineSpacing(-1)
                                .foregroundColor(Color(white: 0.25))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // In bag
                        VStack {
                            Text("In bag")
                                .font(.callout).bold()
                            Image(systemName: disc.inBag ? "checkmark.circle" : "xmark.circle")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: geo.size.width * 0.15, alignment: .trailing)
                    }
                    .frame(width: geo.size.width * widthFactor)
                    
                    Spacer()
                        .frame(height: geo.size.height * 0.05)
                    
                    // Flight numbers
                    DiscFlightNumbers(disc: disc, geo: geo)
                        .frame(width: geo.size.width * widthFactor)
                    
                    Spacer()
                        .frame(height: geo.size.height * 0.05)
                    
                    // Other information
                    DiscOtherInfo(disc: disc, geo: geo)
                        .frame(width: geo.size.width * widthFactor, height: geo.size.width * widthFactor)
                        .padding(.bottom)
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
            // Enable scrolling on smaller screen sizes to maintain layout consistency
            .scrollDisabled(UIScreen.main.bounds.height >= 812)
        }
    }
    
    // MARK: - Nested structs
    
    // This struct provides a view that displays flight numbers for a Disc
    struct DiscFlightNumbers: View {
        
        // MARK: - Properties
        
        // ObservedObject
        
        @ObservedObject var disc: Disc
        
        // Basic
        
        //let geo: GeometryProxy
        let minWidthFactor = 0.1
        let backgroundOpacityFactor = 0.4
        let foregroundOpacityFactor = 0.65
        
        // MARK: - Initializers
        
        init(disc: Disc, geo: GeometryProxy) {
            self.disc = disc
            //self.geo = geo
        }
        
        // MARK: - Body view
        
        var body: some View {
                
            // Main HStack
            HStack(spacing: 20) {
                
                // Speed
                ZStack(alignment: .bottom) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.green.opacity(backgroundOpacityFactor))
                        .aspectRatio(1.0, contentMode: .fit)
                    
                    // Text
                    Text("Speed")
                        .font(.subheadline.bold())
                        .offset(y: -5)
                        .padding(.horizontal, 5)
                        .opacity(foregroundOpacityFactor)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.speed.formatted())
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 7)
                        .opacity(foregroundOpacityFactor)
                        .offset(y: -8),
                    alignment: .center
                )
                
                // Glide
                ZStack(alignment: .bottom) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.yellow.opacity(backgroundOpacityFactor))
                        .aspectRatio(1.0, contentMode: .fit)
                    
                    // Text
                    Text("Glide")
                        .font(.subheadline.bold())
                        .offset(y: -5)
                        .padding(.horizontal, 5)
                        .opacity(foregroundOpacityFactor)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.glide.formatted())
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 7)
                        .opacity(foregroundOpacityFactor)
                        .offset(y: -8),
                    alignment: .center
                )
                
                // Turn
                ZStack(alignment: .bottom) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.pink.opacity(backgroundOpacityFactor))
                        .aspectRatio(1.0, contentMode: .fit)
                    
                    // Text
                    Text("Turn")
                        .font(.subheadline.bold())
                        .offset(y: -5)
                        .padding(.horizontal, 5)
                        .opacity(foregroundOpacityFactor)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.turn.formatted())
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 7)
                        .opacity(foregroundOpacityFactor)
                        .offset(y: -8),
                    alignment: .center
                )
                
                // Fade
                ZStack(alignment: .bottom) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.indigo.opacity(backgroundOpacityFactor))
                        .aspectRatio(1.0, contentMode: .fit)
                    
                    // Text
                    Text("Fade")
                        .font(.subheadline.bold())
                        .offset(y: -5)
                        .padding(.horizontal, 5)
                        .opacity(foregroundOpacityFactor)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.fade.formatted())
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 7)
                        .opacity(foregroundOpacityFactor)
                        .offset(y: -8),
                    alignment: .center
                )
            }
        }
    }
    
    // This struct provides a view that displays additional disc information about a Disc
    struct DiscOtherInfo: View {
        
        // MARK: - Properties
        
        // ObservedObject
        
        @ObservedObject var disc: Disc
        
        // Basic
        
        let geo: GeometryProxy
        let spacing = 0.06
        let backgroundColor = Color.cyan.opacity(0.2)
        let foregroundOpacityFactor = 0.65
        
        // MARK: - Initializers
        
        init(disc: Disc, geo: GeometryProxy) {
            self.disc = disc
            self.geo = geo
        }
        
        // MARK: - Body view
        
        var body: some View {
                
            // 2x2 grid
            VStack(spacing: geo.size.width * spacing) {
                    
                // Row 1
                HStack(spacing: geo.size.width * spacing) {
                    
                    // Type
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(backgroundColor)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        
                        // Field name
                        Text("Type")
                            .font(.headline)
                            .opacity(foregroundOpacityFactor)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(disc.wrappedType)
                            .font(.largeTitle.bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .opacity(foregroundOpacityFactor)
                            .padding(.horizontal, 10),
                        alignment: .center
                    )
                    
                    // Plastic
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(backgroundColor)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        
                        // Field name
                        Text("Plastic")
                            .font(.headline)
                            .opacity(foregroundOpacityFactor)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(disc.wrappedPlastic)
                            .font(.largeTitle.bold())
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                            .opacity(foregroundOpacityFactor)
                            .padding(.horizontal, 10),
                        alignment: .center
                    )
                }
                
                // Row 2
                HStack(spacing: geo.size.width * spacing) {
                    
                    // Weight
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(backgroundColor)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        
                        // Field name
                        Text("Weight")
                            .font(.headline)
                            .opacity(foregroundOpacityFactor)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text("\(disc.weight.formatted())g")
                            .font(.largeTitle.bold())
                            .opacity(foregroundOpacityFactor),
                        alignment: .center
                    )
                    
                    // Condition
                    ZStack(alignment: .bottomLeading) {
                        
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(backgroundColor)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        
                        // Field name
                        Text("Condition")
                            .font(.headline)
                            .opacity(foregroundOpacityFactor)
                            .offset(x: 10, y: -10)
                    }
                    .overlay(
                        // Field value
                        Text(disc.wrappedCondition)
                            .font(.largeTitle.bold())
                            .opacity(foregroundOpacityFactor),
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
