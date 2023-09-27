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

    // Basic

    let disc: Disc

    // MARK: - Body view

    var body: some View {

        // Main stack
        VStack {
            
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
                        MapPolyline(coordinates: [throwStartLocation.coordinate, currentLocation])
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
            
            // Header view
            .safeAreaInset(edge: .top) {
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
                .background(Material.regular)
            }
            
            // Footer view
            .safeAreaInset(edge: .bottom) {
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
                            .foregroundStyle(Color.primary)
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
        }
        .navigationTitle("Measure Throw")
        
        // When the user's location is updated, calculate the distance between the user and the starting point
        .onReceive(locationManager.$currentLocation, perform: { _ in
            guard let throwStartLocation,
                  let currentLocation = locationManager.currentLocation,
                  throwEndLocation == nil else { return }
            let startPoint = CLLocation(latitude: throwStartLocation.coordinate.latitude, longitude: throwStartLocation.coordinate.longitude)
            let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            distance = currentCLLocation.distance(from: startPoint)
        })
    }
    
    // MARK: - Functions
    
    // Set the throw starting location
    func setStartLocation(_ location: CLLocationCoordinate2D) {
        throwStartLocation = Location(name: "Start", coordinate: location)
        buttonTitle = "Mark Ending Location"
    }
    
    // Set the throw ending location
    func setEndLocation(_ location: CLLocationCoordinate2D) {
        
        // Set throw end location
        throwEndLocation = Location(name: "End", coordinate: location)
        
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
    
    // Save the throw to Core Data
    func saveThrow() {
        
        // Create new Disc and assign values
        let newThrow = MeasuredThrow(context: moc)
        newThrow.date = Date.now
        newThrow.disc = disc
        newThrow.distance = distance
        
        try? moc.save() // TODO: Catch errors
        
        dismiss()
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
