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
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            Map(coordinateRegion: $model.region,
                annotationItems: model.locations )
            { loc in
                MapAnnotation(coordinate: loc.coordinate) {
                    VStack {
                        Image(loc.imageRef)
                            .resizable()
                            .frame(width: 44, height: 22)
                        Text(loc.label)
                    }
                }
            }
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
        
    var centerLatitude: String {
        String(format: "%+.6f", model.region.center.latitude)
    }
    
    var centerLongitude: String {
        String(format: "%+.6f", model.region.center.longitude)
    }
    
    func starAction() {
        print("starAction")
//        withAnimation {
//            print("starAction withAnimation")
//            model.next()
//        }
        model.next()
    }
}

let locationFont = Font
    .system(size: 20)
    .monospaced()

#Preview {
    MapTabView()
        .environmentObject(LocationModel.example)
}
