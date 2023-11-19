//
//  SwiftGlobe_iOS_View.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import SwiftUI

struct SwiftGlobeBridgeView: View {
    
    @EnvironmentObject var model: LocationModel
    
    var body: some View {
        ZStack {
            SwiftGlobeBridgeRep(location: model.currentLocation)
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
                    .background(.white)
                Text("lon: \(centerLongitude)")
                    .font(locationFont)
                    .background(.white)
            }
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
        withAnimation {
            print("starAction withAnimation")
            model.next()
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
