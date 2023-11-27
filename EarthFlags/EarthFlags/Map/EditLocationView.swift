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
    
    var body: some View {
        //        NavigationView {
        Form {
            Section {
                TextField("Place label", text: $locationModel.label)
            }
            //                Section("Nearby…") {
            //                    switch locationModel.loadingState {
            //                    case .loading:
            //                        Text("Loading…")
            //                    case .loaded:
            //                        NearbyView(locationModel: locationModel)
            //                    case .failed:
            //                        Text("Please try again later.")
            //                    }
            //                }
        }
        //            .navigationTitle("Place details")
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
        //            .task {
        //                await locationModel.fetchNearbyPlaces()
        //            }
        //        }
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
