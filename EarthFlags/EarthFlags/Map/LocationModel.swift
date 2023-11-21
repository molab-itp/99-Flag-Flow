//
//  MapRegionModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import Foundation
import MapKit

@MainActor class LocationModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.630566,    // Brooklyn Flatlands
            longitude: -73.922013),
        span: MKCoordinateSpan(
            latitudeDelta: 100.0,
            longitudeDelta: 100.0)
    )
    @Published var locations = [Location()]
    var currentLocation = Location()
    var index = 0

    static let main = LocationModel()

    static var sample:LocationModel {
        let model = LocationModel();
        model.locations = knownLocations
        return model
    }

    func locationMatch(_ current:Location) -> Bool {
        print("locationMatch current", current, "center", region.center)
        let epsilon = 0.000001;
        let center = region.center
        return abs(current.latitude - center.latitude) < epsilon
            && abs(current.longitude - center.longitude) < epsilon
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
    
//    func nextUnknown() {
//        print("LocationModel nextUnknown index", index, "locations.count", locations.count)
//        if locations.count <= 0 {
//            return;
//        }
//        index = (index + 1) % locations.count;
//        let cl = locations[index];
//        
//        currentLocation = cl;
//        region = cl.region
//
//    }
    
    func restoreFrom(marked: Array<String>) {
        print("LocationModel restoreFrom marked", marked)
        var newLocs = [Location]()
        for ccode in marked {
            let loc = knownLocations.filter {
                $0.id == ccode
            }
            if loc.isEmpty {
                print("LocationModel restoreFrom !!@ Unknown ccode", ccode)
//                var name = "";
//                if let flagItem = AppModel.main.flagItem(ccode: ccode) {
//                    name = "-"+flagItem.name
//                }
//                let id = "Unk-" + ccode + name
//                let unk = Location(id: id, latitude: 22.0, longitude: -172.0, label: id);
//                newLocs.append(unk)
                continue
            }
            newLocs.append(loc[0])
        }
        locations = newLocs;
        if !newLocs.isEmpty {
            index = 0;
            currentLocation = newLocs[0];
            region = currentLocation.region;
        }
    }
}

let knownLocations:[Location] = [
    Location(delta: 5.0), // USA Brooklyn Flatlands
    Location(id: "USA", latitude: 38.883333, longitude: -77.016667, label: "USA", capital: "Washington, D.C."),
//    // ... label: "United Kingdom of Great Britain"
    Location(id: "GBR", latitude: 51.500000, longitude: -0.1166670, label: "UK", capital: "London"),
    Location(id: "JAM", latitude: 17.983333, longitude: -76.800000, label: "Jamaica", capital: "Kingston"),
    Location(id: "GUY", latitude: 6.8058330, longitude: -58.150833, label: "Guyana", capital: "Georgetown"),
    Location(id: "GHA", latitude: 5.5550000, longitude: -0.1925000, label: "Ghana", capital: "Accra"),
    Location(id: "EGY", latitude: 30.033333, longitude: 31.2166670, label: "Egypt", capital: "Cairo")
];

class Location: Identifiable, Codable {
    internal init(
            id: String = "USA Brooklyn Flatlands",
            latitude: Double = 40.630566,
            longitude: Double = -73.922013,
            label: String = "USA Brooklyn Flatlands",
            capital: String = "Brooklyn Flatlands",
            delta: Double = 100.0) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.label = label
        self.capital = capital
        self.delta = delta
    }
    
    var id = "USA Brooklyn Flatlands"
    var latitude = 40.630566
    var longitude = -73.922013
    var label = "USA Brooklyn Flatlands"
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

// https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction
// https://github.com/twostraws/HackingWithSwift.git

