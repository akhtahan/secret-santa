//
// FriendsHelper.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-19.
// 
//
// 
//


import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    var locationUpdated: ((CLLocationCoordinate2D) -> Void)?
    
    private override init() {
        super.init()
        self.requestPermissionToAccessLocation()
    }
    
    func requestPermissionToAccessLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .denied:
            break
        default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print(#function, "location access is granted always")
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print(#function, "location access is granted when in use")
            manager.startUpdatingLocation()
        default:
            print("error")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            print(location)
            locationUpdated?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Location access failed due to error: \(error)")
    }
}


