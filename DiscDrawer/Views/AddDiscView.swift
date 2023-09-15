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
        
        // Main VStack
        VStack {
            
            // Template search
            NavigationLink {
                DiscTemplateList(showingAddView: $showingAddView, inDiscFinder: false)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(white: 0.9))
                    
                    Text("Search for disc")
                        .font(.title.bold())
                    
                }
                .padding([.horizontal, .top], 50)
                .padding(.bottom, 25)
            }
            
            // Manual creation
            NavigationLink {
                AddEditDiscView(showingAddView: $showingAddView)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(white: 0.9))
                    
                    Text("Manually create disc")
                        .font(.title.bold())
                        .padding()
                }
                .padding([.horizontal, .bottom], 50)
                .padding(.top, 25)
            }
        }
        .toolbar {
            Button {
                showingAddView = false
            } label: {
                Image(systemName: "xmark")
            }
        }
    }
}

struct AddDiscView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiscView(showingAddView: .constant(true))
    }
}
