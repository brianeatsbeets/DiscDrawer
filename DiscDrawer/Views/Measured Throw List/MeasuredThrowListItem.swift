//
//  MeasuredThrowListItem.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/27/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a single measured throw styled for a list
struct MeasuredThrowListItem: View {
    
    // MARK: - Properties
    
    @ObservedObject var measuredThrow: MeasuredThrow
    
    // MARK: - Body view
    
    var body: some View {
        HStack {
            
            // Disc image
            Group {
                if let imageData = measuredThrow.disc?.imageData,
                   let discImage = UIImage(data: imageData) {
                    Image(uiImage: discImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundColor(.red)
                        .scaledToFit()
                }
            }
            .frame(height: 60)
            .padding(.trailing, 8)
            
            // Throw info
            VStack(alignment: .leading) {
                
                // Disc name
                Text(measuredThrow.disc?.wrappedName ?? "Unknown disc")
                    .font(.title3.bold())
                
                // Date
                Text(measuredThrow.date?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown date")
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Distance
            Text("\((measuredThrow.distance * 3.28084), specifier: "%.2f") ft")
                .font(.title.bold())
        }
    }
}
