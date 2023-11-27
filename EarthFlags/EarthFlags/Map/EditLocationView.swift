//
//  EditView.swift
//  Bucketlist
//
//  Created by Paul Hudson on 09/12/2021.
//

import SwiftUI

struct EditLocationView: View {
    
    @EnvironmentObject var locationModel: LocationModel
//    var onSave: (Location) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var flagItem = AppModel.main.flagItem
    
    var body: some View {
        // NavigationView {
        Form {
            Section {
                HStack {
                    Text("label:")
                    // .frame(width:160)
                    TextField("", text: $locationModel.label)
                }
            }
            Section {
                HStack {
                    Text("code:")
                    Text(flagItem?.alpha3 ?? "")
                }
                HStack {
                    Text("name:")
                    Text(flagItem?.name ?? "")
                }
                HStack {
                    Text("latitude:")
                    Text(locationModel.centerLatitude)
                }
                HStack {
                    Text("longitude:")
                    Text(locationModel.centerLongitude)
                }

            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Update") {
                    locationModel.currentLocation.label = locationModel.label
                    locationModel.updateLocation()
                    withAnimation {
                        locationModel.restoreLocation()
                    }
                    dismiss()
                }
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
        .environmentObject(LocationModel.main)
}
