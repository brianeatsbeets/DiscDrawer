//
//  DiscTemplateDetailView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/17/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays information about a disc template
struct DiscTemplateDetailView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.dismiss) var dismiss
    
    // Basic
    
    let discTemplate: DiscTemplate
    let widthFactor = 0.85
    
    // MARK: - Body view
    
    var body: some View {
        
        GeometryReader { geo in
                
            // Main VStack
            VStack {
                
                Spacer()
                
                // Disc name and manufacturer
                VStack {
                    Text(discTemplate.wrappedName)
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(discTemplate.wrappedManufacturer)
                        .font(.title3.bold())
                        .foregroundStyle(Color.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color(white: 0.25))
                }
                
                Spacer()
                    .frame(height: 20)
                
                // Disc type
                DiscTemplateDetailType(type: discTemplate.wrappedType)
                .frame(width: geo.size.width * widthFactor, height: geo.size.height * 0.12)
                
                Spacer()
                    .frame(height: 20)
                
                // Flight numbers
                DiscTemplateDetailFlightNumbers(discTemplate: discTemplate, geo: geo)
                    .frame(width: geo.size.width * widthFactor, height: geo.size.width * widthFactor)
                    .padding(.bottom)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Nested structs
    
    
    
    
}

//struct DiscTemplateDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscTemplateDetailView(disc: disc)
//    }
//}
