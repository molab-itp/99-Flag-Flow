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
//    enum LoadingState {
//        case loading, loaded, failed
//    }
//    @Published var loadingState = LoadingState.loading
//    @Published var pages = [Page]()
    
    // --
    // Set in MapTabView editForm
    @Published var ccode: String = ""
    @Published var label: String = ""
    @Published var flagCode: String = ""
    @Published var description: String = ""
    @Published var duration: Double = 3.0
    @Published var capital: String = ""
    @Published var mapSymbol: String = ""
    
    // --
    var animating = false
    var wasAnimating = false
    var animStart: TimeInterval = 0
    var targetLoc: Location?
//    var startLoc: Location?
    var startRegion: MKCoordinateRegion?
    var startLabel: String?
    var targetIndex = 0

    var animPause = false
    var animPauseStart: TimeInterval = 0
    var animPauseDuration: TimeInterval = 1.0
    
    func stepAnimation() {
        // print("stepAnimation");
        let now = Date.timeIntervalSinceReferenceDate
        if animPause {
            let lapse = now - animPauseStart
            if lapse > animPauseDuration {
                animPause = false
                nextLocation( true)
                startAnimation()
            }
        }
        if !animating {
            return
        }
        if !wasAnimating {
            animStart = Date.timeIntervalSinceReferenceDate
            wasAnimating = true
        }
        let lapse = now - animStart
        if lapse >= duration {
            stopAnimationSegment();
            return
        }
        print("stepAnimation lapse", lapse)
        guard let targetLoc, let startRegion else {
            print("stepAnimation no targetLoc startRegion")
            return
        }
        let perCent = lapse / duration
        region.center.latitude = startRegion.center.latitude + (targetLoc.latitude - startRegion.center.latitude) * perCent
        region.center.longitude = startRegion.center.longitude + (targetLoc.longitude - startRegion.center.longitude) * perCent
        region.span.latitudeDelta = startRegion.span.latitudeDelta + (targetLoc.delta - startRegion.span.latitudeDelta) * perCent
        region.span.longitudeDelta = startRegion.span.longitudeDelta + (targetLoc.delta - startRegion.span.longitudeDelta) * perCent

    }

    // Continue animation to next if mapSymbol is dotted
    func stopAnimationSegment() {
        let isAnimating = animating
        stopAnimation();
        if isAnimating && mapSymbol.contains(".dotted") {
            animPause = true
            animPauseStart = Date.timeIntervalSinceReferenceDate

//            nextLocation( true)
//            startAnimation()
        }
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
        prepareAnimation(animated, delta: -1)
    }
    
    func nextLocation(_ animated: Bool = false) {
        print("LocationModel next index", index, "locations.count", locations.count)
        prepareAnimation(animated, delta: 1)
    }
    
    func prepareAnimation(_ animated: Bool = false, delta: Int) {
        if animated {
            // Animation requested
            if animating {
                // Already animating, stop and return
                stopAnimation()
                return
            }
            else {
                startAnimation()
            }
        }
        else {
            // Animation not requested
            // stop any animation in progress
            stopAnimation()
        }
        adjustLocation(delta)
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
//            startLoc = locations[index]
            startLabel = label
            startRegion = region
            targetLoc = locations[newIndex]
            targetIndex = newIndex
        }
        else {
            establishLocation(newIndex);
        }
    }

    func establishLocation(_ newIndex: Int) {
        if newIndex >= locations.count {
            return;
        }
        let loc = locations[newIndex]
        index = newIndex;
        currentLocation = loc;
        region = loc.region
        label = loc.label
        ccode = loc.ccode
        duration = loc.duration
        flagCode = loc.flagCode ?? loc.ccode
        description = loc.description ?? ""
        capital = loc.capital
        mapSymbol = loc.mapSymbol ?? "circle"
        
        appModel.currentFlagItem(loc.ccode)
    }
    
    // --
    
    func addLocation() {
        print("LocationModel addLocation " );
        let id = ccode+"-"+UUID().uuidString;
        let delta = min(region.span.latitudeDelta, region.span.longitudeDelta)
        var nlabel = label;
        // For labels with dash, replace with ccode count
        if let dashIndex = nlabel.lastIndex(of: "-") {
            // String splicing Partial range recommend over substring
            nlabel = String(nlabel[..<dashIndex])
        }
        let noff = locations.filter { $0.ccode == ccode }
        nlabel = nlabel+"-"+String(noff.count + 1)
        let loc = Location( id: id,
                            ccode: ccode,
                            latitude: region.center.latitude,
                            longitude: region.center.longitude,
                            label: nlabel,
                            capital: capital,
                            delta: delta,
                            flagCode: flagCode,
                            description: description,
                            mapSymbol: mapSymbol
        )
        appModel.addLocation(loc: loc, after: index)
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
        
        currentLocation.flagCode = flagCode
        currentLocation.description = description
        currentLocation.mapSymbol = mapSymbol

        appModel.saveSettings()
    }
    
    // --
    
    func setLocation(ccode: String) {
        if let index = locations.firstIndex(where: { $0.ccode == ccode }) {
            setLocation(index: index)
        }
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

    // --

    func currentLabel() -> String {
        if animating, let targetLoc, let startLabel {
            return startLabel + "..." + targetLoc.label
        }
        var nlabel = currentLocation.label;
        let description = currentLocation.description ?? "";
        if !description.isEmpty {
            nlabel = nlabel + " - " + description;
        }
        return nlabel
    }

    // --
    // region is update by Map
    
    func locationCoordsMatch() -> Bool {
        let current = currentLocation
        let center = region.center
        let epsilon = 0.000001;
        return abs(current.latitude - center.latitude) < epsilon
        && abs(current.longitude - center.longitude) < epsilon
    }
    
    func locationUpdated() -> Bool {
        let cmapSymbol = currentLocation.mapSymbol ?? "circle"
        return currentLocation.ccode != ccode
        || currentLocation.label != label
        || currentLocation.flagCode != flagCode
        || currentLocation.description != description
        || currentLocation.duration != duration
        || currentLocation.capital != capital
        || cmapSymbol != mapSymbol
        || !locationCoordsMatch()
    }

    func restoreLocation() {
        region = currentLocation.region
    }
    
    var centerLatitude: String {
        String(format: "%+.6f", region.center.latitude)
    }
    
    var centerLongitude: String {
        String(format: "%+.6f", region.center.longitude)
    }
    
    // --
    
    func flagItem(ccode: String) -> FlagItem? {
        appModel.flagItem(ccode: ccode)
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

