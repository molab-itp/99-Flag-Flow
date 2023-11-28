//
//  EditView.swift
//  Bucketlist
//
//  Created by Paul Hudson on 09/12/2021.
//

import SwiftUI

struct EditLocationView: View {
    
    var action = "Update"
    
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var locationModel: LocationModel
//    var onSave: (Location) -> Void
    
    @Environment(\.dismiss) var dismiss
    
//    var flagItem = AppModel.main.flagItem
    
    var body: some View {
        // NavigationView {
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
            Section {
                HStack {
                    Text("latitude:")
                    Text(locationModel.centerLatitude)
                }
                HStack {
                    Text("longitude:")
                    Text(locationModel.centerLongitude)
                }
                if let flagItem = locationModel.flagItem(ccode: locationModel.ccode) {
                    HStack {
                        Image(flagItem.imageRef)
                            .resizable()
                            .frame(width: 40, height: 20)
                        Text(flagItem.alpha3 )
                        Text(flagItem.name)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Update or Add
                Button(action) {
                    if action == "Update" {
                        locationModel.currentLocation.label = locationModel.label
                        locationModel.updateLocation()
                        withAnimation {
                            locationModel.restoreLocation()
                        }
                    }
                    else {
                        // Add a location.
                        print("location add")
                        locationModel.addLocation();
                    }
                    dismiss()
                }
            }
            
        }
        .onAppear() {
            print("EditLocationView onAppear locationModel.ccode", locationModel.ccode)
            if action == "Add" {
                locationModel.ccode = ""
            }
        }
    }

//    init(location: Location, onSave: @escaping (Location) -> Void) {
//        self.onSave = onSave
//        _locationModel = StateObject(wrappedValue: LocationModel(location: location))
//    }
}

struct NearbyView: View {
    var locationModel: LocationModel
    var body: some View {
        ForEach(locationModel.pages, id: \.pageid) { page in
            Group {
                Text(page.title)
                    .font(.headline)
                + Text(": ")
                + Text(page.description)
                    .italic()
            }
            .onTapGesture {
                locationModel.label = page.title
//                locationModel.description = page.description
            }
        }
    }
}

#Preview {
    EditLocationView()
        .environmentObject(AppModel.sample)
        .environmentObject(LocationModel.main)
}
