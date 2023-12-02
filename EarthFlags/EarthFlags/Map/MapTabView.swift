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
                        .font(.footnote)
                    TextField("", text: $locationModel.label)
                }
                HStack {
                    Text("description:")
                        .font(.footnote)
                    TextField("", text: $locationModel.description)
                }
                HStack {
                    Text("seconds:")
                        .font(.footnote)
                    TextField("", value: $locationModel.duration, format: .number)
                }
                Picker("map symbol", selection: $locationModel.mapSymbol) {
                    Text("star").tag("star")
                    Text("triangle").tag("triangle")
                    Text("circle").tag("circle")
                    Text("circle.fill").tag("circle.fill")
                    Text("circle.dotted").tag("circle.dotted")
                    // Text("minus").tag("minus")
                    Text("minus").tag("minus.square")
                    Text("plus").tag("plus")
                    Text("plus.square").tag("plus.square")
                    Text("square").tag("square")
                    Text("square.dotted").tag("square.dotted")
                    Text("hexagon").tag("hexagon")
                    Text("pentagon").tag("pentagon")
                    Text("dot.square").tag("dot.square")
                    // smallcircle.filled.circle
                    // target
                    // smallcircle.filled.circle.fill
                    // Text("dot.scope").tag("dot.scope")
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
                    editButtonLabel("Update")
                }
            }
            Button(action: {
                // showingEditToggle()
                addAction()
                nextLocAction()
            } ) {
                editButtonLabel("Add")
            }
            Button(action: showingEditToggle ) {
                editButtonLabel("Close")
            }
        }
    }
    
    func editButtonLabel(_ label: String) -> some View {
        Text(label)
            .foregroundColor(.white)
            .padding(8)
            .background(Color(.systemIndigo))
            .cornerRadius(12)
    }
        
    func map() -> some View {
        Map(coordinateRegion: $locationModel.region,
            annotationItems: appModel.settings.locations )
        { loc in
            MapAnnotation(coordinate: loc.coordinate) {
                HStack {
                    Image(systemName: loc.mapSymbol ?? "circle" )
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
            NavigationLink(
                destination:
                    LocationListView()
            ) {
                Image(systemName: "list.bullet" )
            }
            if !locationModel.locationCoordsMatch() {
                Button(action: restoreLocAction ) {
                    Image(systemName: "staroflife.circle" )
                }
            }
        }
    }
    
    func rightToolbarButtons() -> some View {
        Group {
            Button(action: showingEditToggle ) {
                Image(systemName: "arrow.down.app" )
            }
            Button(action: previousLocAction  ) {
                Image(systemName: "arrow.left.square" )
            }
            Button(action: nextLocAction ) {
                Image(systemName: "arrow.right.square" )
            }
        }
    }
    
    func topInfo() -> some View {
        VStack {
            VStack {
                // Without Rectangle HStack extends into top buttons
                Rectangle()
                    .frame(height: 0)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                HStack {
                    Image("flag-\(locationModel.ccode)")
                        .resizable()
                        .frame(width: 44, height: 22)
                    Text(locationModel.currentLabel())
                }
                .padding(2)
                .background(Color(.init(red: 0, green: 0, blue: 1, alpha: 0.2)))
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
            .opacity(0.5)
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
