//
//  MapRegionModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import Foundation
import MapKit

class LocationModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.630566,    // Brooklyn Flatlands
            longitude: -73.922013),
        span: MKCoordinateSpan(
            latitudeDelta: 100.0,
            longitudeDelta: 100.0)
    )
    var locations = [Location()]
    var currentLocation = Location()
    var index = 0

    static var sample:LocationModel {
        let model = LocationModel();
        model.locations = [
            Location(delta: 5.0), // USA Brooklyn Flatlands
//            Location(id: "GBR", latitude: 51.5, longitude: -0.116667 , label: "United Kingdom of Great Britain", capital: "London", delta: 5.0),
            Location(id: "GBR", latitude: 51.5, longitude: -0.116667 , label: "UK", capital: "London", delta: 5.0),
            Location(id: "JAM", latitude: 17.983333, longitude: -76.8, label: "Jamaica", capital: "Kingston", delta: 5.0),
            Location(id: "GUY", latitude: 6.805833, longitude: -58.150833, label: "Guyana", capital: "Georgetown", delta: 5.0),
            Location(id: "GHA", latitude: 5.555, longitude: -0.1925, label: "Ghana", capital: "Accra", delta: 5.0)
        ]
        return model
    }

    func next() {
        print("LocationModel next index", index, "locations.count", locations.count)
        if locations.count <= 0 {
            return;
        }
        index = (index + 1) % locations.count;
        let cl = locations[index];
        // print("LocationModel next cl", cl)
        region = cl.region
        // print("LocationModel next region", region)
        currentLocation = cl;
        // print("LocationModel next currentLocation", currentLocation)
    }
}

struct Location: Identifiable, Codable, Equatable {
    var id = "USA"
    var latitude = 40.630566
    var longitude = -73.922013
    var label = "USA"
    var capital = "Brooklyn Flatlands"
    var delta = 100.0
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var imageRef: String {
        "flag-\(id)"
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            span: MKCoordinateSpan(
                latitudeDelta: delta,
                longitudeDelta: delta)
        )
    }
}
