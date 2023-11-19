//
//  MapViewTab.swift
//  MoGallery
//
//  Created by jht2 on 2/1/23.
//

import SwiftUI
import MapKit

struct MapTabView: View {

    @EnvironmentObject var model: LocationModel

//    var locs: [Location]
    
    // !!@ Would like use mapRegion, but fails
    // Get warnings, but at least we don't crash
    //    !!@ Modifying state during view update, this will cause undefined behavior.
    //    !!@ Publishing changes from within view updates is not allowed, this will cause undefined behavior.
    
//    @State var locIndex = 0
//    @State var regionLabel = "USA"
//    @State var region =  initRegion()    //    @State var delta = 100.0
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            Map(coordinateRegion: $model.region,
                annotationItems: model.locations )
            { loc in
                // MapMarker(coordinate: loc.coordinate)
                MapAnnotation(coordinate: loc.coordinate) {
                    VStack {
                        Image(loc.imageRef)
                            // Image(systemName: "star.circle")
                            .resizable()
                            .frame(width: 44, height: 22)
                            // .foregroundColor(.red)
                            // .background(.white)
                            // .clipShape(Circle())
                        Text(loc.label)
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
                    Button(action: starAction ) {
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
//                Text(model.region.label)
//                    .font(locationFont)
            }
        }
        .onAppear {
            print("MapView onAppear locations", model.locations)
//            locIndex = 0
//            setRegionMain(0);
        }
    }
    
//    func setRegionMain (_ offset: Int) {
//        print("MapView setRegionMain offset", offset)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//            setRegionState(offset)
//        }
//    }
//    
//    func setRegionState(_ offset: Int) {
//        print("MapView setRegionState offset", offset)
//        if locIndex >= locs.count || locs.count < 1 { return }
//        locIndex = (locIndex + offset ) % locs.count
//        let loc = locs[locIndex]
//        regionLabel = loc.label
//        let delta = loc.delta
////        region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
//        print("MapView setRegionState offset", offset, "loc", loc, "index", locIndex)
//    }
    
    var centerLatitude: String {
        String(format: "%+.6f", model.region.center.latitude)
    }
    
    var centerLongitude: String {
        String(format: "%+.6f", model.region.center.longitude)
    }
    
    func starAction() {
        print("starAction")
        withAnimation {
//            print("starAction index", locIndex, "locations.count", locs.count)
//            setRegionMain(1)
            print("starAction withAnimation")
            model.next()
        }
    }
}

let locationFont = Font
    .system(size: 20)
    .monospaced()

#Preview {
    MapTabView()
        .environmentObject(LocationModel.example)
}
