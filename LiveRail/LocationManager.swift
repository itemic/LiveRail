//
//  LocationManager.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    public static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // for station details, might need to update later on

    
    @Published var status: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var location: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isActive: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    

    
//    @Published var placemark: CLPlacemark? {
//        willSet {
//            objectWillChange.send()
//        }
//    }
    func pause() {
        locationManager.stopUpdatingLocation()
        self.isActive = false
    }
    
    func resume() {
        locationManager.startUpdatingLocation()
        self.isActive = true
    }
    
    override init() {
        self.isActive = true
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    

    func closestStation(stations: [Station]) -> Station? {
        guard let location = self.location else {return nil}
        locationManager.requestLocation()
        let closest = stations.min {
            location.distance(from: $0.coordinates) < location.distance(from: $1.coordinates)
        }
        return closest
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        self.status = status
//    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.status = manager.authorizationStatus
        print("Change")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last  else {return}
        self.location = location
        self.locationManager.stopUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    
}


extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}


