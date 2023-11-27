//
//  LocationListView.swift
//  EarthFlags
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject var appModel: AppModel
//    @EnvironmentObject var locationModel: LocationModel

    var body: some View {
        VStack {
            Text("\(appModel.locations.count) Locations")
                .font(.caption)
                .padding()
            List {
                ForEach(appModel.locations) { loc in
                    HStack {
                        if let flagItem = appModel.flagItem(ccode: loc.ccode) {
                            Image(flagItem.imageRef)
                                .resizable()
                                .frame(width: 40, height: 20)
                        }
                        Text(loc.label)
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete )
            }
            .toolbar {
                EditButton()
            }
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        //print("FlagMarkedView move", source, destination)
        appModel.moveLocation(from: source, to: destination)
    }
    func delete( indices: IndexSet) {
        //print("onDelete", indices)
        withAnimation {
            appModel.deleteLocation(indices: indices)
        }
    }
    
}

#Preview {
    LocationListView()
        .environmentObject(AppModel.sample)
        .environmentObject(LocationModel.sample)
}
