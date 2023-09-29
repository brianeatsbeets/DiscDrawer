//
//  MeasureThrowView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import MapKit
import SwiftUI

// MARK: - Main struct

// This struct provides a view that allows the user to measure the distance of their throw via location
struct MeasureThrowView: View {

    // MARK: - Properties
    
    // Environment

    // Managed object context
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    // State object
    
    // Calls locationManagerDidChangeAuthorization on init
    @StateObject var locationManager = LocationManager()

    // State
    
    @State private var throwStartLocation: Location?
    @State private var throwEndLocation: Location?
    @State private var buttonTitle = "Mark Starting Location"
    @State private var distance = 0.0
    @State private var mapInteractionModes: MapInteractionModes = .all
    
    // Binding
    
    @Binding var showingSelectDiscView: Bool

    // Basic

    let disc: Disc
    
    var locationAccuracy: String {
        if let accuracy = locationManager.currentLocation?.horizontalAccuracy {
            return Int((accuracy * 3.28084).rounded()).description
        } else {
            return "Unknown"
        }
    }

    // MARK: - Body view

    var body: some View {

        // Main stack
        ZStack(alignment: .bottomTrailing) {
            
            // Map view
            Map(position: $locationManager.mapCameraPosition, interactionModes: mapInteractionModes) {
                
                // User location annotation
                if throwEndLocation == nil {
                    UserAnnotation()
                }
                
                if let throwStartLocation {
                    
                    // Throw start location annotation
                    Marker(throwStartLocation.name, coordinate: throwStartLocation.coordinate)
                    
                    // Line from throw start to current location
                    if let currentLocation = locationManager.currentLocation {
                        MapPolyline(coordinates: [throwStartLocation.coordinate, currentLocation.coordinate])
                            .stroke(.white, lineWidth: 7)
                    }
                }
                
                // Throw end location annotation
                if let throwEndLocation {
                    Marker(throwEndLocation.name, coordinate: throwEndLocation.coordinate)
                }
            }
            
            // Use satellite imagery
            .mapStyle(.imagery)
            
            // Accuracy view
            VStack(alignment: .trailing) {
                Text("Accuracy")
                    .fontWeight(.heavy)
                
                HStack(spacing: 0) {
                    Image(systemName: "plusminus")
                        .font(.body)
                    Text("\(locationAccuracy)ft")
                }
            }
            .font(.headline)
            .padding(12)
            .background(Material.thick)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(x: -20, y: -20)
        }
        .navigationTitle("Measure Throw")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
            // Prevent the device from auto-sleeping
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            
            // Allow the device to auto-sleep
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .safeAreaInset(edge: .top) {
            
            // Header view
            HStack {
                Spacer()
                
                // Header text
                if throwStartLocation == nil {
                    Text("Set your starting point")
                        .font(.title.bold())
                        .padding()
                } else {
                    Text("Distance: \((distance * 3.28084), specifier: "%.2f") feet")
                        .font(.title.bold())
                        .padding()
                }
                
                Spacer()
            }
            .background(Material.thick)
        }
        .safeAreaInset(edge: .bottom) {
            
            // Footer view
            HStack {
                Spacer()
                
                // Button to mark the throw locations
                Button {
                    
                    // Make sure we have the user's current location
                    if let currentLocation = locationManager.currentLocation {
                        
                        if throwStartLocation == nil {
                            setStartLocation(currentLocation)
                        } else if throwEndLocation == nil {
                            setEndLocation(currentLocation)
                        } else {
                            saveThrow()
                        }
                    } else {
                        print("Unable to get current location.")
                    }
                } label: {
                    Text(buttonTitle)
                        .font(.title3.bold())
                        .foregroundStyle(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                        )
                }
                .padding(.top)
                
                Spacer()
            }
            .background(.thinMaterial)
        }
        .onReceive(locationManager.$currentLocation, perform: { _ in
            
            // When the user's location is updated, calculate the distance between the user and the starting point
            calculateCurrentDistance()
        })
    }
    
    // MARK: - Functions
    
    // Set the throw starting location
    func setStartLocation(_ location: CLLocation) {
        throwStartLocation = Location(name: "Start", coordinate: location.coordinate)
        buttonTitle = "Mark Ending Location"
    }
    
    // Set the throw ending location
    func setEndLocation(_ location: CLLocation) {
        
        // Set throw end location
        throwEndLocation = Location(name: "End", coordinate: location.coordinate)
        
        // Stop tracking user location
        locationManager.stopUpdatingLocation()
        
        // Disable map interaction
        mapInteractionModes = []
        
        // Pan map to frame annotations
        withAnimation {
            locationManager.mapCameraPosition = .automatic
        }
        
        buttonTitle = "Save Throw"
    }
    
    // Calculate the distance between the user and the starting point
    func calculateCurrentDistance() {
        guard let throwStartLocation,
              let currentLocation = locationManager.currentLocation,
              throwEndLocation == nil else { return }
        let startPoint = CLLocation(latitude: throwStartLocation.coordinate.latitude, longitude: throwStartLocation.coordinate.longitude)
        let currentCLLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        distance = currentCLLocation.distance(from: startPoint)
    }
    
    // Save the throw to Core Data
    func saveThrow() {
        
        // Create new Disc and assign values
        let newThrow = MeasuredThrow(context: moc)
        newThrow.date = Date.now
        newThrow.disc = disc
        newThrow.distance = distance
        
        try? moc.save() // TODO: Catch errors
        
        showingSelectDiscView = false
    }
    
    // MARK: - Nested structs
    
    // Helper struct to store saved location information
    struct Location: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
        
        static func == (lhs: Location, rhs: Location) -> Bool {
            lhs.id == rhs.id
        }
    }
}
