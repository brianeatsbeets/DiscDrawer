//
//  ContentView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that serves as the base container for the app
struct ContentView: View {
    
    // MARK: - Properties
    
    // Environment
    
    // Managed object context
    @Environment(\.managedObjectContext) var moc
    
    // State
    
    @State private var showingAddScreen = false
    @State private var viewMode = "list"
    @State private var sortAsc = true
    @State private var sortItemIndex = 0
    
    @State private var showingLogoView = true
    
    // Basic
    
    // Computed sort descriptor to pass to FilteredList
    var sortDescriptor: SortDescriptor<Disc> {
        if sortItemIndex == 0 {
            return SortDescriptor(\.name, order: sortAsc ? .forward : .reverse)
        } else {
            return SortDescriptor(\.manufacturer, order: sortAsc ? .forward : .reverse)
        }
    }
    
    // MARK: - Body view
    
    var body: some View {
        
        // ZStack for LogoView
        ZStack {
            
            // Navigation view
            NavigationView {
                
                // Main VStack
                VStack {
                    
                    // Sort and filter elements
                    HStack {
                        
                        // Sort button
                        Button {
                            sortAsc.toggle()
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        
                        // Filter picker
                        Picker("Filter Field", selection: $sortItemIndex) {
                            Text("Name").tag(0)
                            Text("Manufacturer").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)
                    
                    // Disc list
                    FilteredList(viewMode: viewMode, sortDescriptor: sortDescriptor)
                        .toolbar {
                            
                            // View mode button
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    if viewMode == "list" {
                                        viewMode = "grid"
                                    } else {
                                        viewMode = "list"
                                    }
                                } label: {
                                    Image(systemName: viewMode == "grid" ? "list.bullet" : "square.grid.2x2")
                                }
                            }
                            
                            // Add disc button
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showingAddScreen.toggle()
                                } label: {
                                    Label("Add Disc", systemImage: "plus")
                                }
                            }
                        }
                        .sheet(isPresented: $showingAddScreen) {
                            
                            // Manually add navigation view here to avoid adding a second navigation view when passing a disc
                            NavigationView {
                                AddEditDiscView()
                            }
                            .interactiveDismissDisabled()
                        }
                }
                .navigationTitle("Disc Drawer")
            }
            
            // Logo view
            if showingLogoView {
                LogoView()
                    .zIndex(1) // Keep view on top while dismissing
                    .transition(.move(edge: .top))
            }
        }
        .onAppear {
            
            // Logo view dismiss animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.2)) {
                    showingLogoView.toggle()
                }
            }
        }
    }
}

// MARK: - Preview provider

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
