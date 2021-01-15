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
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    let objectWillChange = PassthroughSubject<Void, Never>()
    
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
    
    @Published var placemark: CLPlacemark? {
        willSet {
            objectWillChange.send()
        }
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func geocode() {
        guard let location = self.location else {return}
        geocoder.reverseGeocodeLocation(location) { (places, error) in
            if error == nil {
                self.placemark = places?[0]
            } else {
                self.placemark = nil
            }
        }
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestPermissionThen(completion: () -> Void) {
        locationManager.requestWhenInUseAuthorization()
    }
    func closestStation(locations: [Station]) -> Station? {
        guard let location = self.location else {return nil}
        return locations.min {
            location.distance(from: $0.coordinates) < location.distance(from: $1.coordinates)
        }
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        self.status = status
//    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.status = manager.authorizationStatus
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last  else {return}
        self.location = location
        self.geocode()
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


