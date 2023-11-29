//
//  LocationListView.swift
//  EarthFlags
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var locationModel: LocationModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("\(appModel.locations.count) Locations")
                .font(.caption)
                .padding()
            List {
                ForEach(appModel.locations) { loc in
                    Button(action: {
                        locationModel.setLocation(id: loc.id)
                        dismiss()
                    } ) {
                        HStack {
                            Image(systemName: loc.mapSymbol ?? "circle" )
                                .resizable()
                                .frame(width: 30, height: 30)
                            if let flagItem = appModel.flagItem(ccode: loc.ccode) {
                                Image(flagItem.imageRef)
                                    .resizable()
                                    .frame(width: 40, height: 20)
                            }
                            Text(loc.label)
                        }
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete )
            }
            .toolbar {
                // ToolbarItemGroup(placement: .navigationBarLeading) {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { } ) {
                        Image(systemName: "square.and.arrow.up.on.square" )
                    }
                    Button(action: { } ) {
                        Image(systemName: "square.and.arrow.down.on.square" )
                    }
                    EditButton()
                }
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
