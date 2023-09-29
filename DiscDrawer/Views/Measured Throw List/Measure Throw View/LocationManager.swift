//
//  LocationManager.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/25/23.
//

// MARK: - Imported libraries

import MapKit
import SwiftUI

// MARK: - Main class

// This class provides manages user location authorization and provides location data
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Properties

    // Published

    @Published var mapCameraPosition = MapCameraPosition.automatic
    @Published var currentLocation: CLLocation?

    // Basic

    let manager = CLLocationManager()
    var didSetInitialLocation = false

    // MARK: - Initializers

    override init() {
        super.init()
        
        // Set the LocationManager object as the CLLocationManager object's delegate
        manager.delegate = self
        
        // Use the most accurate accuracy reading
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Functions

    // Delegate function that provides an up-to-date location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Make sure we have a usable location
        guard let currentLocation = locations.last else { return }
        
        // Update the stored current location
        self.currentLocation = currentLocation
        print()

        // Set the initial map camera position based on the user's location
        if !didSetInitialLocation {
            mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan()))
            didSetInitialLocation = true
        }
    }

    // Delegate function that runs when an error occurs when determining location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    // Delegate function that runs when the CLLocationManager object is created and when the location authorization is changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        switch manager.authorizationStatus {
            
        // If location access is authorized, start tracking
        case .authorizedWhenInUse:
            print("Approved location authorization")
            manager.startUpdatingLocation()
            
            // checkLocationAccuracyAuthorization()
            
        // If location access is denied, stop tracking
        // TODO: Display an alert explaining that we are unable to measure throws without location access and direct the user to the location settings
        case .restricted, .denied:
            print("Restricted or denied location authorization")
            manager.stopUpdatingLocation()
            
        // If location access is not determined, request access
        case .notDetermined:
            print("Location authorization not specified - requesting authorization...")
            manager.requestWhenInUseAuthorization()
            
        default:
            break
        }
    }
    
    // Disable location tracking
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    // Handle different levels of accuracy authorization
    func checkLocationAccuracyAuthorization() {
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            print("Location accuracy is set to full")
        case .reducedAccuracy:
            print("Location accuracy is set to reduced")
            // TODO: Add key to info.plist when Xcode stops crashing when trying to add it (https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationtemporaryusagedescriptiondictionary)
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Precise location is needed to get the most accurate measurement for your throw.")
        @unknown default:
            break
        }
    }
}
