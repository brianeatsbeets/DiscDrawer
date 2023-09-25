//
//  DiscDetailOtherInfo.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays additional disc information about a Disc
struct DiscDetailOtherInfo: View {
    
    // MARK: - Properties
    
    // ObservedObject
    
    @ObservedObject var disc: Disc
    
    // Basic
    
    let geo: GeometryProxy
    let spacing = 0.06
    let backgroundColor = Color.cyan.opacity(0.2)
    
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
                        .strokeBorder(.cyan, lineWidth: 3)
                        .background(
                            Color.cyan
                                .brightness(0.3)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 20)
                                )
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    // Field name
                    Text("Type")
                        .font(.headline)
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5))
                        .offset(x: 10, y: -10)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.wrappedType)
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5))
                        .padding(.horizontal, 10),
                    alignment: .center
                )
                
                // Plastic
                ZStack(alignment: .bottomLeading) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.cyan, lineWidth: 3)
                        .background(
                            Color.cyan
                                .brightness(0.3)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 20)
                                )
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    // Field name
                    Text("Plastic")
                        .font(.headline)
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5))
                        .offset(x: 10, y: -10)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.wrappedPlastic)
                        .font(.largeTitle.bold())
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5))
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
                        .strokeBorder(.cyan, lineWidth: 3)
                        .background(
                            Color.cyan
                                .brightness(0.3)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 20)
                                )
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    // Field name
                    Text("Weight")
                        .font(.headline)
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5))
                        .offset(x: 10, y: -10)
                }
                .overlay(
                    
                    // Field value
                    Text(disc.weight != 0 ? "\(disc.weight.formatted())g" : "N/A")
                        .font(.largeTitle.bold())
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5)),
                    alignment: .center
                )
                
                // Condition
                ZStack(alignment: .bottomLeading) {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.cyan, lineWidth: 3)
                        .background(
                            Color.cyan
                                .brightness(0.3)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 20)
                                )
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    // Field name
                    Text("Condition")
                        .font(.headline)
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5))
                        .offset(x: 10, y: -10)
                }
                .overlay(
                    // Field value
                    Text(disc.wrappedCondition)
                        .font(.largeTitle.bold())
                        .foregroundColor(.cyan)
                        .colorMultiply(Color(white: 0.5)),
                    alignment: .center
                )
            }
        }
    }
}

//#Preview {
//    DiscDetailOtherInfo()
//}
