//
//  ContentView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

import SwiftUI

struct ContentView: View {
    
    // Managed object context
    @Environment(\.managedObjectContext) var moc
    
    @State private var showingAddScreen = false
    @State private var viewMode = "list"
    @State private var sortAsc = true
    @State private var sortItemIndex = 0
    
    var sortDescriptor: SortDescriptor<Disc> {
        if sortItemIndex == 0 {
            return SortDescriptor(\.name, order: sortAsc ? .forward : .reverse)
        } else {
            return SortDescriptor(\.manufacturer, order: sortAsc ? .forward : .reverse)
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                HStack {
                    Button {
                        sortAsc.toggle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    Picker("Filter Field", selection: $sortItemIndex) {
                        Text("Name").tag(0)
                        Text("Manufacturer").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                FilteredList(viewMode: viewMode, sortDescriptor: sortDescriptor)
                    .navigationTitle("DiscDrawer")
                    .toolbar {
                        
                        // View mode button
                        ToolbarItem(placement: .navigationBarLeading) {
                            Menu {
                                Button("List") {
                                    viewMode = "list"
                                }
                                Button("Grid") {
                                    viewMode = "grid"
                                }
                                Button("Carousel") {
                                    viewMode = "carousel"
                                }
                            } label: {
                                Text("View mode")
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
