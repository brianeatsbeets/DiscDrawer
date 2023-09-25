//
//  DiscTemplateDetailType.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays flight numbers for a Disc
struct DiscTemplateDetailType: View {
    
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

//#Preview {
//    DiscTemplateDetailType()
//}
