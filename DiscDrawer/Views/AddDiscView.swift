//
//  AddDiscView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/12/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that allows the user to choose to create a new disc from an existing template or to manually enter the information
struct AddDiscView: View {
    
    // MARK: - Properties
    
    @Binding var showingAddView: Bool
    
    // MARK: - Body view
    
    var body: some View {
        
        GeometryReader { geo in
            
            // Main VStack
            VStack(spacing: 30) {
                
                Spacer()
                
                // Template search
                NavigationLink {
                    DiscTemplateList(showingAddView: $showingAddView, inDiscFinder: false)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: UIColor.quaternaryLabel))
                        
                        Text("Search for disc")
                            .font(.title.bold())
                            .padding()
                    }
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.4, alignment: .center)
                }
                
                // Manual creation
                NavigationLink {
                    AddEditDiscView(showingAddView: $showingAddView)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: UIColor.quaternaryLabel))
                        
                        Text("Manually create disc")
                            .font(.title.bold())
                            .padding()
                    }
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.4, alignment: .center)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .toolbar {
                Button {
                    showingAddView = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

struct AddDiscView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiscView(showingAddView: .constant(true))
    }
}
