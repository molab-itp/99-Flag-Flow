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
    @State private var lastTime: TimeInterval = 0.0
    @State private var lastDate: Date?
    
    var body: some View {
//        let _ = Self._printChanges()
        NavigationStack {
            VStack {
//                if let lastDate = lastDate {
//                    Text(lastDate.ISO8601Format() )
//                }
                if showingEdit {
                    editForm()
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
            .onReceive(timer) { arg in
                lastDate = arg
                let now = arg.timeIntervalSinceReferenceDate
                //                    print("MapTabView onReceive timer now", now)
                //                    let diff = now - lastTime
                //                    print("", diff)
                lastTime = now
            }
            .onAppear {
                print("MapTabView onAppear")
            }
            .onDisappear() {
                print("MapTabView onDisappear")
            }
        }
    }
    
    func editForm() -> some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Text("label:")
                        // .frame(width:160)
                        TextField("", text: $locationModel.label)
                    }
                    HStack {
                        Text("ccode:")
                        // .frame(width:160)
                        TextField("", text: $locationModel.ccode)
                    }
                    HStack {
                        Text("duration:")
                        // .frame(width:160)
                        TextField("", value: $locationModel.duration, format: .number)
                    }
                }
            }
            Button(action: {
                showingEditToggle()
                updateAction()
            } ) {
                Text("Update")
            }
            Button(action: {
                showingEditToggle()
                addAction()
            } ) {
                Text("Add")
            }
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
    
    func map() -> some View {
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
    }

    func showingEditToggle() {
        withAnimation {
            showingEdit.toggle()
        }
    }
    
    func leftToolbarButtons() -> some View {
        Group {
//            NavigationLink(
//                destination:
//                    EditLocationView(action: "Add")
//            ) {
//                Image(systemName: "plus" )
//            }
//            NavigationLink(
//                destination:
//                    EditLocationView()
//            ) {
//                Image(systemName: "arrow.down.app" )
//            }
            Button(action: {
                showingEditToggle()
            } ) {
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
            if !locationModel.locationMatch(locationModel.currentLocation) {
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
        let duration = locationModel.currentLocation.duration
        print("previousLocAction duration", duration)
//        withAnimation(.linear(duration: duration)) {
        withAnimation  {
            locationModel.previousLocation()
        }
    }
    
    func nextLocAction() {
        let duration = locationModel.currentLocation.duration
        print("nextLocAction duration", duration)
//        withAnimation(.linear(duration: duration)) {
        withAnimation  {
            locationModel.nextLocation()
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
        .environmentObject(AppModel.sample)
        .environmentObject(LocationModel.sample)
}
