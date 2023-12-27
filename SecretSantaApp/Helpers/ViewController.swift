//
// ViewController.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-12-10.
// 
//
// 
//

import Foundation
import CoreLocation
import MapKit

struct Place: Hashable {
    let name: String
    let address: String
}

func openMap(address: String) {
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { placemarks, error in
        guard let location = placemarks?.first?.location else {
            print("Error: Unable to find the location for the address.")
            return
        }

        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        mapItem.name = address

        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        //check if maps app is installed
        if mapItem.openInMaps(launchOptions: launchOptions) {
            print("Opened in Maps app.")
        } else {
            //open in browser if maps app not available
            if let url = URL(string: "http://maps.apple.com/?address=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
//                UIApplication.shared.open(url)
            } else {
                print("Error: Unable to create a valid URL for the address.")
            }
        }
    }
}

class PlacesViewModel: ObservableObject {
    
    @Published var places: [Place] = []


     init() {
         LocationService.shared.locationUpdated = { [weak self] location in
             self?.fetchPlaces(location: location)
         }
    }
    
    
    func fetchPlaces(location: CLLocationCoordinate2D) {
        let searchSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let searchRegion = MKCoordinateRegion(center: location, span: searchSpan)

        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = searchRegion
        searchRequest.resultTypes = .pointOfInterest
        searchRequest.naturalLanguageQuery = "Shops"

        let search = MKLocalSearch(request: searchRequest)

        search.start { response, error in
            guard let mapItems = response?.mapItems else {
                return
            }
            
            
            let results = mapItems.map { mapItem in
                            return Place(
                                name: mapItem.name ?? "No Name Found",
                                address: mapItem.placemark.title ?? "No Address Found"
                            )
                        }
            
            
            DispatchQueue.main.async { [weak self] in
                self?.places = results
            }
        }
    }
}
