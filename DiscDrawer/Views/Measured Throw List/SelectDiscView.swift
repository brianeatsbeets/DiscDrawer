//
//  SelectDiscView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/27/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of discs from which to select to measure a throw
struct SelectDiscView: View {
    
    // MARK: - Properties

    // Environment

    // Managed object context
    @Environment(\.managedObjectContext) var moc
    
    // Fetch request
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var discs: FetchedResults<Disc>
    
    // Binding
    
    @Binding var showingSelectDiscView: Bool
    
    // MARK: - Body view
    
    var body: some View {
        List {
            ForEach(discs) { disc in
                
                NavigationLink {
                    MeasureThrowView(showingSelectDiscView: $showingSelectDiscView, disc: disc)
                } label: {
                    HStack {
                        
                        // Disc image
                        Group {
                            if let imageData = disc.imageData,
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
                        
                        // Disc name
                        Text(disc.wrappedName)
                            .font(.title2.bold())
                    }
                }
            }
        }
        .navigationTitle("Select a disc")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingSelectDiscView = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}
