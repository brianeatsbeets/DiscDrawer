//
//  FilterPicker.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 10/6/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a custom segmented control-style picker view
struct FilterPicker: View {
    
    // MARK: - Properties
    
    // Binding
    
    @Binding var selectionIndex: Int
    
    // Basic
    
    let items: [String]
    
    // Initializers
    
    init(items: [String], selection: Binding<Int>) {
        self.items = items
        _selectionIndex = selection
    }
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main ZStack
        ZStack {
            
            GeometryReader { geo in
                
                // Selected item background
                Capsule()
                    .fill(.mint)
                    .frame(width: geo.size.width / CGFloat(items.count), height: geo.size.height)
                    .shadow(color: Color(white: 0.5, opacity: 0.5), radius: 2, y: 2)
                    .offset(x: geo.size.width / CGFloat(items.count) * CGFloat(selectionIndex))
                    .animation(.smooth(duration: 0.3), value: selectionIndex)
            }
            
            HStack {
                
                // Picker options
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.footnote)
                        .fontWeight(item == items[selectionIndex] ? .heavy : .semibold)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.5)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectionIndex = items.firstIndex(of: item)!
                        }
                        .animation(nil, value: selectionIndex)
                        .foregroundStyle(item == items[selectionIndex] ? Color.white : Color(white: 0.4))
                        .animation(.smooth(duration: 0.2), value: selectionIndex)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, maxHeight: 35)
        .background(Capsule().fill(.mint).brightness(0.7))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.mint, lineWidth: 2))
    }
}

// MARK: - Preview

struct BindingPreview: View {
    @State private var selection = 0
    
    var body: some View {
        FilterPicker(items: ["Speed", "Name", "Manufacturing"], selection: $selection)
    }
}

#Preview {
    BindingPreview()
}
