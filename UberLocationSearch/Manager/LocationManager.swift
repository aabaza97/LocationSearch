//
//  LocationManager.swift
//  UberLocationSearch
//
//  Created by Ahmed Abaza on 13/09/2021.
//

import Foundation
import CoreLocation

class LocationManger: NSObject {
    //MARK: - satitcs
    static let shared = LocationManger()
    
    
    //MARK: - properties
    private let manager = CLLocationManager()
    
    
    //MARK: -functions
    public func findLocations (with searchQuery: String, completionHandler: @escaping ([Location]) -> Void) -> Void {
        let coder = CLGeocoder()
        
        coder.geocodeAddressString(searchQuery) { places, error in
            guard let places = places, error == nil else { completionHandler([]); return }
            
            let locations: [Location] = places.compactMap { place in
                let name = "\(place.name ?? ""), \(place.administrativeArea ?? ""), \(place.locality ?? ""), \(place.country ?? "")"
                return Location(title: name, flatCoordinates: place.location?.coordinate)
            }
            completionHandler(locations)
        }
    }
}
