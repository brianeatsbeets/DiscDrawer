//
//  LocationManager.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            //break
            authorizationStatus = .authorizedWhenInUse
            manager.startUpdatingLocation()

        case .restricted, .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            //break
            authorizationStatus = .denied

        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }
}
