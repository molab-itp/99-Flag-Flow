//
//  Location.swift
//  EarthFlags
//
//  Created by jht2 on 11/26/23.
//

import Foundation
import MapKit

class Location: Identifiable, Codable, Equatable {
    
    var id = "USA Brooklyn Flatlands"
    var ccode = "USA"
    var latitude = 40.630566
    var longitude = -73.922013
    var label = "USA Brooklyn Flatlands"
    var capital = "Brooklyn Flatlands"
    var delta = 100.0
    var duration = 3.0
    var flagCode: String?
    var description: String?
    var mapSymbol: String?
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    internal init(
        id: String = "USA Brooklyn Flatlands",
        ccode: String = "USA",
        latitude: Double = 40.630566,
        longitude: Double = -73.922013,
        label: String = "USA Brooklyn Flatlands",
        capital: String = "Brooklyn Flatlands",
        delta: Double = 100.0,
        duration: Double = 3.0,
        flagCode: String = "",
        description: String = "",
        mapSymbol: String = ""
    ) {
        self.id = id
        self.ccode = ccode
        self.latitude = latitude
        self.longitude = longitude
        self.label = label
        self.capital = capital
        self.delta = delta
        self.duration = duration
        self.flagCode = flagCode
        self.description = description
        self.mapSymbol = mapSymbol
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var imageRef: String {
        "flag-\(ccode)"
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

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude
        && lhs.center.longitude == rhs.center.longitude
        && lhs.span.latitudeDelta == rhs.span.latitudeDelta
        && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

// https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction
// https://github.com/twostraws/HackingWithSwift.git

