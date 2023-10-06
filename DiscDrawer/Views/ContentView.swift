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
    @FetchRequest(sortDescriptors: []) var discs: FetchedResults<Disc>

    // State

    @State private var viewMode = "list"
    @State private var sortAsc = true
    @State private var sortItemIndex = 0

    @State private var showingLogoView = true
    @State private var showingAddView = false
    @State private var showingTemplatesView = false

    // Basic

    // Dev property to choose whether or not to display the logo view
    var splashScreenEnabled = true

    // Computed sort descriptor to pass to FilteredDiscView
    var sortDescriptor: SortDescriptor<Disc> {
        switch sortItemIndex {
        case 0:
            return SortDescriptor(\.speed, order: sortAsc ? .forward : .reverse)
        case 1:
            return SortDescriptor(\.name, order: sortAsc ? .forward : .reverse)
        case 2:
            return SortDescriptor(\.manufacturer, order: sortAsc ? .forward : .reverse)
        default:
            return SortDescriptor(\.speed, order: sortAsc ? .forward : .reverse)
        }
    }

    // MARK: - Body view

    var body: some View {

        // ZStack for LogoView
        ZStack {

            TabView {

                // Tab item for discs
                NavigationView {

                    // Main VStack
                    VStack(spacing: 0) {

                        // Sort and filter elements
                        HStack {
                            
                            // Sort button
                            Button {
                                sortAsc.toggle()
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                            }
                            
                            // Filter picker
                            FilterPicker(items: ["Speed", "Name", "Manufacturer"], selection: $sortItemIndex)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)

                        // Only display the disc list if it's not empty
                        if discs.isEmpty {

                            Spacer()

                            GroupBox {
                                Text("It's a little dusty in here!")
                                    .font(.title.weight(.medium))
                                    .padding(.bottom, 20)
                                Text("Tap the \(Image(systemName: "plus")) button to start adding discs.")
                                    .font(.body)
                            }

                            Spacer()
                            Spacer()
                        } else {
                            FilteredDiscView(viewMode: viewMode, sortDescriptor: sortDescriptor)
                        }
                    }
                    .navigationTitle("Disc Drawer")
                    .navigationBarTitleDisplayMode(.inline)
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
                                showingAddView.toggle()
                            } label: {
                                Label("Add Disc", systemImage: "plus")
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showingAddView) {

                        // Manually add navigation view here to avoid adding a second navigation view when passing a disc
                        NavigationView {
                            DiscTemplateList(showingAddView: $showingAddView)
                        }
                        .interactiveDismissDisabled()
                    }
                }
                .tabItem {
                    Label("Discs", systemImage: "tray.full")
                }

                // Tab item for disc finder
                NavigationView {
                    DiscTemplateList()
                }
                .tabItem {
                    Label("Finder", systemImage: "magnifyingglass")
                }
                
                // Tab item for measured throws
                NavigationView {
                    MeasuredThrowList()
                }
                .tabItem {
                    Label("Throws", systemImage: "list.number")
                }
            }

            if splashScreenEnabled {

                // Logo view
                if showingLogoView {
                    LogoView()
                        .zIndex(1) // Keep view on top while dismissing
                        .transition(.move(edge: .top))
                }
            }
        }
        .task {
            if UserDefaults.standard.object(forKey: "DownloadedInitialData") == nil {
                print("Fetching data...")
                await fetchDiscTemplateData()
                print("Fetched data.")
            }
        }
        .onAppear {
            if splashScreenEnabled {

                // Logo view dismiss animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        showingLogoView.toggle()
                    }
                }
            }
        }
    }

    // Fetch disc data from API
    // TODO: Clean up and use response to verify successful data task
    // TODO: Crashes were occasionally happening on first launch before error handling and are now not happening, but no errors are showing up for some reason
    // TODO: Retain the splash screen or show loading message when downloading disc data
    func fetchDiscTemplateData() async {
        let url = URL(string: "https://discit-api.fly.dev/disc/")!

        if let (data, _) = try? await URLSession.shared.data(from: url) {

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = moc

            if let decodedDiscs = try? decoder.decode([DiscTemplate].self, from: data) {
                print(decodedDiscs)
                UserDefaults.standard.set(true, forKey: "DownloadedInitialData")

                if moc.hasChanges {
                    do {
                        try moc.save()
                    } catch {
                        print("Error saving to core data: \(error.localizedDescription)")
                    }
                }

            } else {
                print("Failed to decode.")
            }
        } else {
            print("Failed to get data from URLSession.")
        }
    }
}
