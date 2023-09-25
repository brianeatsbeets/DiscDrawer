//
//  DiscGridItem.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a single disc styled for a grid
struct DiscGridItem: View {
    
    // MARK: - Properties
    
    @ObservedObject var disc: Disc
    
    // MARK: - Body view
    
    var body: some View {
        Group {
            
            // Main VStack
            VStack {
                
                // Disc image
                ZStack {
                    if let imageData = disc.imageData,
                       let discImage = UIImage(data: imageData) {
                        Image(uiImage: discImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    } else {
                        Color.red
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Circle()
                        .stroke(.white, lineWidth: 3)
                }
                .frame(height: 70)
                .padding(.top, 10)
                
                Spacer()
                
                // Disc info
                VStack(spacing: 3) {
                    
                    // Disc name
                    Text(disc.wrappedName)
                        .font(.headline)
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.8)
                    
                    // Disc manufacturer
                    if disc.manufacturer != "" {
                        Text(disc.wrappedManufacturer)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 1)
                            .background(
                                Color.black
                                    .clipShape(Capsule())
                            )
                            .layoutPriority(1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 10)
            .background(Color(white: 0.90))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(height: 150)
    }
}

#Preview {
    DiscGridItem()
}
