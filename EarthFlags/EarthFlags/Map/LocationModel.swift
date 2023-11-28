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
    
    lazy var appModel = AppModel.main
    
    var locations: [Location] {
        appModel.settings.locations
    }

    // --
    enum LoadingState {
        case loading, loaded, failed
    }
    @Published var loadingState = LoadingState.loading
    @Published var pages = [Page]()
    
    // Set in MapTabView editForm
    @Published var label: String = ""
    @Published var ccode: String = ""
    @Published var duration: Double = 3.0

    // --
    var animating = false
    var wasAnimating = false
    var animStart: TimeInterval = 0
    var targetLoc: Location?
    var startLoc: Location?
    var targetIndex = 0

    func currentLabel() -> String {
        if animating, let targetLoc, let startLoc {
            return startLoc.label + " to " + targetLoc.label
        }
        return currentLocation.label
    }
    
    func stepAnimation() {
        // print("stepAnimation");
        let now = Date.timeIntervalSinceReferenceDate
        if !animating {
            return
        }
        if !wasAnimating {
            animStart = Date.timeIntervalSinceReferenceDate
            wasAnimating = true
        }
        let lapse = now - animStart
        if lapse >= duration {
            stopAnimation();
            return
        }
        print("stepAnimation lapse", lapse)
        guard let targetLoc, let startLoc else {
            print("stepAnimation no targetLoc startLoc")
            return
        }
        let perCent = lapse / duration
        region.center.latitude = startLoc.latitude + (targetLoc.latitude - startLoc.latitude) * perCent
        region.center.longitude = startLoc.longitude + (targetLoc.longitude - startLoc.longitude) * perCent
        region.span.latitudeDelta = startLoc.delta + (targetLoc.delta - startLoc.delta) * perCent
        region.span.longitudeDelta = startLoc.delta + (targetLoc.delta - startLoc.delta) * perCent

    }
    
    func startAnimation() {
        animStart = Date.timeIntervalSinceReferenceDate
        animating = true
        wasAnimating = false
    }
    
    func stopAnimation () {
        let isAnimating = animating
        animating = false
        wasAnimating = false
        if isAnimating {
            establishLocation(targetIndex)
        }
    }

    func previousLocation(_ animated: Bool = false) {
        print("LocationModel previous index", index, "locations.count", locations.count)
        prepareAnimation(animated)
        adjustLocation(-1)
    }
    
    func nextLocation(_ animated: Bool = false) {
        print("LocationModel next index", index, "locations.count", locations.count)
        prepareAnimation(animated)
        adjustLocation(1)
    }
    
    func prepareAnimation(_ animated: Bool = false) {
        if animated {
            startAnimation()
        }
        else {
            stopAnimation()
        }
    }
    
    func adjustLocation(_ delta: Int) {
        print("adjustLocation previous delta", delta, "index", index, "locations.count", locations.count)
        if locations.count <= 0 {
            return;
        }
        let newIndex = (index + delta + locations.count) % locations.count;
        setLocation(index: newIndex)
    }
    
    func setLocation(index newIndex: Int) {
        print("LocationModel setLocation index", index, "locations.count", locations.count)
        if animating {
            startLoc = locations[index]
            targetLoc = locations[newIndex]
            targetIndex = newIndex
        }
        else {
            establishLocation(newIndex);
        }
    }

    func establishLocation(_ newIndex: Int) {
        let loc = locations[newIndex]
        index = newIndex;
        region = loc.region
        currentLocation = loc;
        label = loc.label
        ccode = loc.ccode
        duration = loc.duration
        appModel.currentFlagItem(loc.ccode)
    }
    
    // --
    
    var centerLatitude: String {
        String(format: "%+.6f", region.center.latitude)
    }
    
    var centerLongitude: String {
        String(format: "%+.6f", region.center.longitude)
    }

    func addLocation() {
        print("LocationModel addLocation " );
        // let ccode = currentLocation.ccode
        let id = ccode+"-"+UUID().uuidString;
        let delta = min(region.span.latitudeDelta, region.span.longitudeDelta)
        let loc = Location( id: id,
                            ccode: ccode,
                            latitude: region.center.latitude,
                            longitude: region.center.longitude,
                            label: label,
                            capital: "",
                            delta: delta)
        appModel.addLocation(loc: loc, after: index)
    }
    
    func flagItem(ccode: String) -> FlagItem? {
        appModel.flagItem(ccode: ccode)
    }
    
    func updateLocation() {
        print("updateLocation region.span", region.span.latitudeDelta, region.span.longitudeDelta )
        print("updateLocation currentLocation.delta", currentLocation.delta )
        
        currentLocation.latitude = region.center.latitude
        currentLocation.longitude = region.center.longitude
        currentLocation.delta = min(region.span.latitudeDelta, region.span.longitudeDelta)
        
        currentLocation.label = label
        currentLocation.ccode = ccode
        currentLocation.duration = duration

        appModel.saveSettings()
    }
    
    func locationMatch(_ current:Location) -> Bool {
        let epsilon = 0.000001;
        let center = region.center
        return abs(current.latitude - center.latitude) < epsilon
            && abs(current.longitude - center.longitude) < epsilon
    }
    
    func setLocation(id: String) {
        if let index = locations.firstIndex(where: { $0.id == id }) {
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

