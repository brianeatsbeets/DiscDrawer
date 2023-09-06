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
    
    // Fetch request
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var discs: FetchedResults<Disc>
    
    @State private var showingAddScreen = false
    @State private var viewMode = "grid"
    
    var body: some View {
        NavigationView {
            Group {
                if viewMode == "list" {
                    DiscList(discs: discs)
                } else {
                    DiscGrid(discs: discs)
                }
            }
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
    
    // MARK: - Custom views
    
    // List view
    struct DiscList: View {
        
        // Managed object context
        @Environment(\.managedObjectContext) var moc
        
        let discs: FetchedResults<Disc>
        
        var body: some View {
            List {
                ForEach(discs) { disc in
                    NavigationLink {
                        AddEditDiscView(disc: disc)
                    } label: {
                        HStack {
                            Color.red
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(disc.name ?? "Unknown name")
                                    .font(.headline)
                                
                                if disc.manufacturer != "" {
                                    Text(disc.manufacturer ?? "Unknown manufacturer")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.leading, 5)
                        }
                    }
                }
                .onDelete(perform: deleteDiscs) // Perform when item is deleted // Enables swipe-to-delete
            }
        }
        
        // Delete books from the managed object context
        func deleteDiscs(at offsets: IndexSet) {
            for offset in offsets {
                // Find the book in our fetch request
                let disc = discs[offset]

                // Delete it from the context
                moc.delete(disc)
            }

            // Save the context
            try? moc.save()
        }
    }
    
    // Grid view
    struct DiscGrid: View {
        
        // Managed object context
        @Environment(\.managedObjectContext) var moc
        
        let discs: FetchedResults<Disc>
        
        // Grid layout
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
        
        var body: some View {
                
            // Grid and spacer
            ScrollView {
                
                // Grid
                LazyVGrid(columns: columns) {
                    
                    // Grid item
                    ForEach(discs) { disc in
                        NavigationLink {
                            AddEditDiscView(disc: disc)
                        } label: {
                            DiscGridItem(disc: disc)
                        }
                        .padding(.bottom)
                    }
                    .onDelete(perform: deleteDiscs)
                }
                .padding()
                
                Spacer()
            }
        }
        
        struct DiscGridItem: View {
            let disc: Disc
            
            var body: some View {
                Group {
                    
                    // Layout of each cell
                    VStack {
                        
                        // Disc image
                        Color.red
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 70)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        // Disc information
                        VStack(spacing: 3) {
                            
                            // Name
                            Text(disc.name ?? "Unknown name")
                                .font(.headline)
                                .foregroundColor(.black)
                                .minimumScaleFactor(0.8)
                            
                            // Manufacturer
                            if disc.manufacturer != "" {
                                Text(disc.manufacturer ?? "Unknown manufacturer")
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
        
        struct DiscGridItemAlt: View {
            let disc: Disc
            
            var body: some View {
                Group {
                    
                    // Layout of each cell
                    ZStack {
                        
                        // Disc image
                        Color.red
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .padding(.top, 10)
                        
                        Color(white: 1, opacity: 0.6)
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .padding(.top, 10)
                            
                        // Name
                        Text(disc.name ?? "Unknown name")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 10)
                    .background(Color(white: 0.90))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        
        // Delete books from the managed object context
        func deleteDiscs(at offsets: IndexSet) {
            for offset in offsets {
                // Find the book in our fetch request
                let disc = discs[offset]

                // Delete it from the context
                moc.delete(disc)
            }

            // Save the context
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
