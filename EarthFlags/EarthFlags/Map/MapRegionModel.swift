//
//  MapRegionModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import Foundation
import MapKit

struct MapRegionModel {
    var region = MKCoordinateRegion(
        // 40.630566, -73.922013
        center: CLLocationCoordinate2D(latitude: 40.630566,
                                       longitude: -73.922013),
        //        center: CLLocationCoordinate2D(latitude: 37.334_900,
        //                                       longitude: -122.009_020),
        latitudinalMeters: 1_000_000,
        longitudinalMeters: 1_000_000
    )
    var locIndex = 0
    var regionLabel = ""
    var locs: [Location] = [Location()]
}

struct Location: Identifiable, Codable, Equatable {
    var id: String = "id"
    var latitude: Double = 40.630566
    var longitude: Double = -73.922013
    var label: String = "USA"
    var delta = 100.0
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
