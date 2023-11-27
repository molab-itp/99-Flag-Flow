//
//  MapViewTab.swift
//  MoGallery
//
//  Created by jht2 on 2/1/23.
//

import SwiftUI
import MapKit

struct MapTabView: View {

    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var locationModel: LocationModel

    @State private var showingAddLocationAlert: Bool = false

    var body: some View {
        // let _ = Self._printChanges()
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $locationModel.region,
                    annotationItems: appModel.settings.locations )
                { loc in
                    MapAnnotation(coordinate: loc.coordinate) {
                        VStack {
                            Image(loc.imageRef)
                                .resizable()
                                .frame(width: 44, height: 22)
                            Text(loc.label)
                        }
                        .onTapGesture {
                            withAnimation {
                                print("nextLocAction withAnimation")
                                locationModel.setLocation(loc)
                            }
                        }
                    }
                }
                centerCircle()
                topInfo()
                bottomInfo()
            }
            .onAppear {
//                print("MapTabView onAppear locations", model.locations)
            }
//            .onChange(of: locationModel.region ) { _ in
//                print("MapTabView onAppear region", locationModel.region)
//            }
            // .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(
                        destination:
                            EditLocationView()
                    ) {
                        Image(systemName: "arrow.down.app" )
                    }
                    NavigationLink(
                        destination:
                            LocationListView()
                    ) {
                        Image(systemName: "list.bullet" )
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !locationModel.locationMatch(locationModel.currentLocation) {
                        Button(action: restoreLocAction ) {
                            Image(systemName: "staroflife.circle" )
                        }
                    }
                    Button(action: nextLocAction ) {
                        Image(systemName: "arrow.left.square.fill" )
                    }
                    Button(action: previousLocAction ) {
                        Image(systemName: "arrow.right.square.fill" )
                    }
                }
            }
            .alert("Add location?", isPresented:$showingAddLocationAlert) {
                Button("Ok") {
                    showingAddLocationAlert = false
                }
                Button("Cancel", role: .cancel) {
                    showingAddLocationAlert = false
                }
            }
        }
    }

    func topInfo() -> some View {
        VStack {
            Text(locationModel.currentLocation.label)
            Spacer()
        }
    }
    
    func bottomInfo() -> some View {
        VStack {
            Spacer()
            Text("lat: \(locationModel.centerLatitude)")
                .font(locationFont)
            Text("lon: \(locationModel.centerLongitude)")
                .font(locationFont)
        }
    }

    private func centerCircle() -> some View {
        Circle()
            .fill(.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
    }
        
    func previousLocAction() {
        print("previousLocAction")
        withAnimation {
            print("previousLocAction withAnimation")
            locationModel.previousLocation()
        }
    }
    
    func nextLocAction() {
        print("nextLocAction")
        withAnimation {
            print("nextLocAction withAnimation")
            locationModel.nextLocation()
        }
    }

    func restoreLocAction() {
        print("restoreLocAction")
        withAnimation {
            locationModel.restoreLocation()
        }
    }
    
//    var centerLatitude: String {
//        String(format: "%+.6f", locationModel.region.center.latitude)
//    }
//    
//    var centerLongitude: String {
//        String(format: "%+.6f", locationModel.region.center.longitude)
//    }
    
}

let locationFont = Font
    .system(size: 20)
    .monospaced()

#Preview {
    MapTabView()
        .environmentObject(AppModel.sample)
        .environmentObject(LocationModel.sample)
}
