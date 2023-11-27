//
//  SwiftGlobe_iOS_View.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import SwiftUI

struct SwiftGlobeBridgeView: View {
    
    @EnvironmentObject var locationModel: LocationModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                SwiftGlobeBridgeRep(location: locationModel.currentLocation)
                topInfo()
                bottomInfo()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: nextLocAction ) {
                        //Image(systemName: "arrow.right.circle" )
                        Text("Next")
                    }
                }
            }
        }
    }

    func topInfo() -> some View {
        VStack {
            Text(locationModel.currentLocation.label)
                .background(.white)
            Spacer()
        }
    }
    
    func bottomInfo() -> some View {
        VStack {
            Spacer()
            Text("lat: \(locationModel.centerLatitude)")
                .font(locationFont)
                .background(.white)
            Text("lon: \(locationModel.centerLongitude)")
                .font(locationFont)
                .background(.white)
        }
    }

//    var centerLatitude: String {
//        String(format: "%+.6f", model.region.center.latitude)
//    }
//    
//    var centerLongitude: String {
//        String(format: "%+.6f", model.region.center.longitude)
//    }
    
    func nextLocAction() {
        print("nextLocAction")
        withAnimation {
            print("nextLocAction withAnimation")
            locationModel.nextLocation()
        }
    }

}

struct SwiftGlobeBridgeRep: UIViewControllerRepresentable {
    var location:Location

    func makeUIViewController(context: Context) -> some UIViewController {
        print("BridgeView makeUIViewController location", location)
        
        let storyBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil);
        let viewCtl = storyBoard.instantiateViewController(withIdentifier: "main") as! ViewController;
        
        print("BridgeView viewCtl", viewCtl)
        print("BridgeView viewCtl.swiftGlobe", viewCtl.swiftGlobe)
        
        viewCtl.location = location;
        
        return viewCtl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("BridgeView updateUIViewController")
        let viewCtl = uiViewController as! ViewController
        viewCtl.swiftGlobe.addDemoLocation(location: location)
        viewCtl.setLocation(newLoc: location)
    }
}

#Preview {
    SwiftGlobeBridgeView()
        .environmentObject(LocationModel.sample)
}

// swiftGlobe.focusOnLatLon( 40.630566, -73.922013)
