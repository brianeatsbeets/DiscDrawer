//
//  MeasuredThrowList.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays measured throws in a list
struct MeasuredThrowList: View {
    
    // MARK: - Properties

    // Environment

    // Managed object context
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.distance, order: .reverse)]) var measuredThrows: FetchedResults<MeasuredThrow>
    
    // MARK: - Body view
    
    var body: some View {
        List {
            ForEach(measuredThrows, id: \.self) { measuredThrow in
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
        .navigationTitle("Measured Throws")
    }
}
