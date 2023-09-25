//
//  MeasureThrowView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct MeasureThrowView: View {

    @StateObject var locationManager = LocationManager()

    @State private var mapRegion = MKCoordinateRegion(
        center: .init(latitude: 37.334_900,longitude: -122.009_020),
        span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var locations = [Location]()

    let disc: Disc

    var body: some View {

        VStack {
            Map(coordinateRegion: $mapRegion,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow)
            )
                .navigationTitle("Measure Throw")
                .onAppear {
                    locationManager.requestLocation()
                }
            Button("Mark Throw") {
                if let currentLocation = locationManager.location {
                    locations.append(Location(name: "Test", coordinate: currentLocation))
                    print("Added location: \(currentLocation)")
                } else {
                    print("Unable to get current location.")
                }
            }
        }
    }

    struct Location: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
}
