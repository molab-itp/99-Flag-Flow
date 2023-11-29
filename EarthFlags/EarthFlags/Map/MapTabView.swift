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

    @State private var showingEdit = false

    // Trigger time every 1/10th second
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        // let _ = Self._printChanges()
        NavigationStack {
            VStack {
                if showingEdit {
                    editLocation()
                }
                ZStack {
                    map()
                    centerCircle()
                    topInfo()
                    bottomInfo()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    leftToolbarButtons()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    rightToolbarButtons()
                }
            }
            .onReceive(timer) { dateArg in
                locationModel.stepAnimation()
            }
        }
    }
    
    func editLocation() -> some View {
        VStack {
            editLocButtons()
            editLocForm()
        }
    }
    
    func editLocForm() -> some View {
        Form {
            Section {
                HStack {
                    Text("label:")
                    TextField("", text: $locationModel.label)
                }
                TextField("", text: $locationModel.description)
                HStack {
                    Text("flagCode:")
                    TextField("", text: $locationModel.flagCode)
                }
                HStack {
                    Text("duration:")
                    TextField("", value: $locationModel.duration, format: .number)
                }
                HStack {
                    Text("ccode:")
                    Text(locationModel.ccode)
                }
            }
        }
    }
    
    func editLocButtons() -> some View {
        HStack {
            if locationModel.locationUpdated() {
                Button(action: {
                    // showingEditToggle()
                    updateAction()
                } ) {
                    editButton(label:"Update")
                }
            }
            Button(action: {
                // showingEditToggle()
                addAction()
                nextLocAction()
            } ) {
                editButton(label:"Add")
            }
            Button(action: showingEditToggle ) {
                editButton(label:"Close")
            }
        }
    }
    
    func editButton(label: String) -> some View {
        Text(label)
        // .font(.headline)
            .foregroundColor(.white)
            .padding(8)
            .background(Color(.systemIndigo))
            .cornerRadius(12)
        // .padding(5)
    }
        
    func map() -> some View {
        Map(coordinateRegion: $locationModel.region,
            annotationItems: appModel.settings.locations )
        { loc in
            MapAnnotation(coordinate: loc.coordinate) {
//                VStack {
//                    if let flagCode = loc.flagCode {
//                        Image("flag-\(flagCode)")
//                            .resizable()
//                            .frame(width: 44, height: 22)
//                    }
//                    Text(loc.label)
//                }
                HStack {
//                    Image(systemName: "circle.fill" )
                    Image(systemName: "circle" )
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .onTapGesture {
                    withAnimation {
                        print("nextLocAction withAnimation")
                        locationModel.setLocation(loc)
                    }
                }
            }
        }
    }
    
    func leftToolbarButtons() -> some View {
        Group {
            Button(action: showingEditToggle ) {
                Image(systemName: "arrow.down.app" )
            }
            NavigationLink(
                destination:
                    LocationListView()
            ) {
                Image(systemName: "list.bullet" )
            }
        }
    }
    
    func rightToolbarButtons() -> some View {
        Group {
            if !locationModel.locationCoordsMatch() {
                Button(action: restoreLocAction ) {
                    Image(systemName: "staroflife.circle" )
                }
            }
            Button(action: previousLocAction  ) {
                Image(systemName: "arrow.left.square.fill" )
            }
            Button(action: nextLocAction ) {
                Image(systemName: "arrow.right.square.fill" )
            }
        }
    }
    
    func topInfo() -> some View {
        VStack {
            HStack {
                Image("flag-\(locationModel.ccode)")
                    .resizable()
                    .frame(width: 44, height: 22)
                Text(locationModel.currentLabel())
            }
            if !locationModel.description.isEmpty {
                Text(locationModel.description)
            }
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
    
    // --

    func showingEditToggle() {
        withAnimation {
            showingEdit.toggle()
        }
    }

    func addAction() {
        // Add a location.
        print("location add")
        locationModel.addLocation();
    }
    
    func updateAction() {
        locationModel.currentLocation.label = locationModel.label
        locationModel.updateLocation()
        withAnimation {
            locationModel.restoreLocation()
        }
    }

    func previousLocAction() {
        let duration = locationModel.currentLocation.duration
        print("previousLocAction duration", duration)
//        withAnimation(.linear(duration: duration)) {
        withAnimation  {
            locationModel.previousLocation(!showingEdit)
        }
    }
    
    func nextLocAction() {
        let duration = locationModel.currentLocation.duration
        print("nextLocAction duration", duration)
//        withAnimation(.linear(duration: duration)) {
        withAnimation  {
            locationModel.nextLocation(!showingEdit)
        }
    }

    func restoreLocAction() {
        let duration = locationModel.currentLocation.duration
        print("restoreLocAction duration", duration)
//        withAnimation(.linear(duration: duration)) {
        withAnimation  {
            locationModel.restoreLocation()
        }
    }
    
}

let locationFont = Font
    .system(size: 20)
    .monospaced()

#Preview {
    MapTabView()
        .environmentObject(AppModel.main)
        .environmentObject(LocationModel.main)
}
