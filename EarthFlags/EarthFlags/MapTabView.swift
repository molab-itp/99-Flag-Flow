//
//  MapViewTab.swift
//  MoGallery
//
//  Created by jht2 on 2/1/23.
//

import SwiftUI
import MapKit

var delta = 100.0

struct MapTabView: View {
    // !!@ causes flood of Publishing changes from within view updates
    //    @StateObject var lobbyModel: LobbyModel
    
    var locs: [Location]
    
    // !!@ Would like use mapRegion, but fails
    // Get warnings, but at least we don't crash
    //    !!@ Modifying state during view update, this will cause undefined behavior.
    //    !!@ Publishing changes from within view updates is not allowed, this will cause undefined behavior.
    
    @State var locIndex = 0
    @State var regionLabel = "USA"
    //    @State var region = MKCoordinateRegion(
    //        center: CLLocationCoordinate2D(latitude: 40.630566,
    //                                       longitude: -73.922013),
    //        latitudinalMeters: 2_000_000,
    //        longitudinalMeters: 2_000_000
    //    )
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.630566,
                                       longitude: -73.922013),
        span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
    )
    //    @State var delta = 100.0
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            //  Map(coordinateRegion: locationManager.region,
            //  Map(coordinateRegion: $locationManager.region,
            //  Map(coordinateRegion: $region,
            //      annotationItems: locs )
            //            Map(coordinateRegion: $region,
            Map(coordinateRegion: $region,
                annotationItems: locs )
            { location in
                // MapMarker(coordinate: location.coordinate)
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image("flag-\(location.label)")
                            // Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 22)
                            .background(.white)
                            // .clipShape(Circle())
                        Text(location.label)
                    }
                }
            }
            // .ignoresSafeArea()
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: centerUserLocationAction ) {
                        Image(systemName: "star")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                }
            }
            VStack {
                Spacer()
                Text("lat: \(centerLatitude)")
                    .font(locationFont)
                Text("lon: \(centerLongitude)")
                    .font(locationFont)
                Text(regionLabel)
                    .font(locationFont)
            }
        }
        .onAppear {
            print("MapView onAppear locs", locs)
            locIndex = 0
            setRegionMain(0);
        }
    }
    
    func setRegionMain (_ offset: Int) {
        print("MapView setRegionMain offset", offset)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            setRegionState(offset)
        }
    }
    
    func setRegionState(_ offset: Int) {
        print("MapView setRegionState offset", offset)
        if locIndex >= locs.count || locs.count < 1 { return }
        locIndex = (locIndex + offset ) % locs.count
        let loc = locs[locIndex]
        regionLabel = loc.label
        region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
        print("MapView setRegionState offset", offset, "loc", loc, "locIndex", locIndex)
    }
    
    var centerLatitude: String {
        String(format: "%+.6f", region.center.latitude)
    }
    
    var centerLongitude: String {
        String(format: "%+.6f", region.center.longitude)
    }
    
    func centerUserLocationAction() {
        withAnimation {
            print("centerUserLocationAction locIndex", locIndex, "locs.count", locs.count)
            setRegionMain(1)
        }
    }
}

let locationFont = Font
    .system(size: 20)
    .monospaced()

#Preview {
    MapTabView(locs: [])
        .environmentObject(Model.example)
}
