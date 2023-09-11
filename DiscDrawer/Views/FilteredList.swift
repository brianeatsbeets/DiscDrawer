//
//  FilteredList.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/11/23.
//

import SwiftUI

struct FilteredList: View {
    
    // Uninitialized fetch request
    @FetchRequest var discs: FetchedResults<Disc>
    
    var viewMode: String
    
    init(viewMode: String, sortDescriptor: SortDescriptor<Disc>) {
        self.viewMode = viewMode
        _discs = FetchRequest<Disc>(sortDescriptors: [sortDescriptor])
    }
    
    var body: some View {
        if viewMode == "list" {
            DiscList(discs: discs)
        } else if viewMode == "grid" {
            DiscGrid(discs: discs)
        } else {
            DiscCarousel(discs: discs)
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
                Section("Putter") {
                    ForEach(discs) { disc in
                        
                        if disc.type == "Putter" {
                            DiscListItem(disc: disc)
                        }
                    }
                    .onDelete(perform: deleteDiscs) // Perform when item is deleted // Enables swipe-to-delete
                }
                
                Section("Midrange") {
                    ForEach(discs) { disc in
                        
                        if disc.type == "Midrange" {
                            DiscListItem(disc: disc)
                        }
                    }
                    .onDelete(perform: deleteDiscs) // Perform when item is deleted // Enables swipe-to-delete
                }
                
                Section("Fairway") {
                    ForEach(discs) { disc in
                        
                        if disc.type == "Fairway" {
                            DiscListItem(disc: disc)
                        }
                    }
                    .onDelete(perform: deleteDiscs) // Perform when item is deleted // Enables swipe-to-delete
                }
                
                Section("Driver") {
                    ForEach(discs) { disc in
                        
                        if disc.type == "Driver" {
                            DiscListItem(disc: disc)
                        }
                    }
                    .onDelete(perform: deleteDiscs) // Perform when item is deleted // Enables swipe-to-delete
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
    
    struct DiscListItem: View {
        let disc: Disc
        
        var body: some View {
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
                    
                    Section("Putter") {
                        
                        // Grid item
                        ForEach(discs) { disc in
                            if disc.type == "Putter" {
                                NavigationLink {
                                    AddEditDiscView(disc: disc)
                                } label: {
                                    DiscGridItem(disc: disc)
                                }
                                .padding(.bottom)
                            }
                        }
                        .onDelete(perform: deleteDiscs)
                    }
                    
                    Section("Midrange") {
                        
                        // Grid item
                        ForEach(discs) { disc in
                            if disc.type == "Midrange" {
                                NavigationLink {
                                    AddEditDiscView(disc: disc)
                                } label: {
                                    DiscGridItem(disc: disc)
                                }
                                .padding(.bottom)
                            }
                        }
                        .onDelete(perform: deleteDiscs)
                    }
                    
                    Section("Fairway") {
                        
                        // Grid item
                        ForEach(discs) { disc in
                            if disc.type == "Fairway" {
                                NavigationLink {
                                    AddEditDiscView(disc: disc)
                                } label: {
                                    DiscGridItem(disc: disc)
                                }
                                .padding(.bottom)
                            }
                        }
                        .onDelete(perform: deleteDiscs)
                    }
                    
                    Section("Driver") {
                        
                        // Grid item
                        ForEach(discs) { disc in
                            if disc.type == "Driver" {
                                NavigationLink {
                                    AddEditDiscView(disc: disc)
                                } label: {
                                    DiscGridItem(disc: disc)
                                }
                                .padding(.bottom)
                            }
                        }
                        .onDelete(perform: deleteDiscs)
                    }
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
    
    struct DiscCarousel: View {
        
        // Managed object context
        @Environment(\.managedObjectContext) var moc
        
        let discs: FetchedResults<Disc>
        
        var body: some View {
            GeometryReader { geo in
                
                // Stack
                ZStack {
                    
                    // Stack item
                    ForEach(discs) { disc in
                        NavigationLink {
                            AddEditDiscView(disc: disc)
                        } label: {
                            ZStack {
                                Color.red
                                    .clipShape(Circle())
                                    .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                                Text(disc.name!)
                            }
                        }
                        .padding(.bottom)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

//struct FilteredList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredList()
//    }
//}
