//
//  MapRegionModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import Foundation
import MapKit

//@MainActor 
class LocationModel: ObservableObject {
        
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.630566,    // Brooklyn Flatlands
            longitude: -73.922013),
        span: MKCoordinateSpan(
            latitudeDelta: 100.0,
            longitudeDelta: 100.0)
    )
    @Published var currentLocation = Location()
    var index = 0

    static let main = LocationModel()

    static var sample:LocationModel {
        let model = LocationModel();
        return model
    }
    
    var locations: [Location] {
        AppModel.main.settings.locations
    }

    enum LoadingState {
        case loading, loaded, failed
    }
    @Published var loadingState = LoadingState.loading
    @Published var pages = [Page]()
    @Published var label: String = ""

    var centerLatitude: String {
        String(format: "%+.6f", region.center.latitude)
    }
    
    var centerLongitude: String {
        String(format: "%+.6f", region.center.longitude)
    }

    func updateLocation() {
        print("updateLocation region.span", region.span.latitudeDelta, region.span.longitudeDelta );
        print("updateLocation currentLocation.delta", currentLocation.delta );
        
        currentLocation.latitude = region.center.latitude
        currentLocation.longitude = region.center.longitude
        currentLocation.delta = min(region.span.latitudeDelta, region.span.longitudeDelta);
        
        AppModel.main.saveSettings()
    }
    
    func locationMatch(_ current:Location) -> Bool {
        let epsilon = 0.000001;
        let center = region.center
        return abs(current.latitude - center.latitude) < epsilon
            && abs(current.longitude - center.longitude) < epsilon
    }

    func previousLocation() {
        print("LocationModel previous index", index, "locations.count", locations.count)
        if locations.count <= 0 {
            return;
        }
        index = (index - 1 + locations.count) % locations.count;
        setLocation(index: index)
    }
    
    func nextLocation() {
        print("LocationModel next index", index, "locations.count", locations.count)
        if locations.count <= 0 {
            return;
        }
        index = (index + 1) % locations.count;
        setLocation(index: index)
    }
    
    func setLocation(index: Int) {
        self.index = index;
        let loc = locations[index];
        region = loc.region
        currentLocation = loc;
        label = currentLocation.label
        AppModel.main.currentFlagItem(loc.ccode)
    }
    
    func setLocation(ccode: String) {
        if let index = locations.firstIndex(where: { $0.id == ccode }) {
            setLocation(index: index)
        }
    }
    
    func setLocation(_ location: Location) {
        if let index = locations.firstIndex(of: location) {
            setLocation(index: index);
        }
    }
    
    func restoreLocation() {
        region = currentLocation.region
    }
}

let knownLocations:[Location] = [
    Location(delta: 5.0), // USA Brooklyn Flatlands
    Location(id: "USA", ccode: "USA", latitude: 38.883333, longitude: -77.016667, label: "USA", capital: "Washington, D.C."),
    Location(id: "GBR", ccode: "GBR", latitude: 51.500000, longitude: -0.1166670, label: "UK", capital: "London"),
    Location(id: "JAM", ccode: "JAM", latitude: 17.983333, longitude: -76.800000, label: "Jamaica", capital: "Kingston"),
    Location(id: "GUY", ccode: "GUY", latitude: 6.8058330, longitude: -58.150833, label: "Guyana", capital: "Georgetown"),
    Location(id: "GHA", ccode: "GHA", latitude: 5.5550000, longitude: -0.1925000, label: "Ghana", capital: "Accra"),
    Location(id: "EGY", ccode: "EGY", latitude: 30.033333, longitude: 31.2166670, label: "Egypt", capital: "Cairo")
];

