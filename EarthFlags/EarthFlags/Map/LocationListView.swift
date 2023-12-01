//
//  LocationListView.swift
//  EarthFlags
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var locationModel: LocationModel
    
    @Environment(\.dismiss) var dismiss

    @State private var showingExportAlert: Bool = false
    @State private var showingImportAlert: Bool = false
    
    var body: some View {
        VStack {
            locationListHeader()
            List {
                ForEach(appModel.locations) { loc in
                    let selected = loc.id == locationModel.currentLocation.id
                    if selected {
                        locationListRow(loc)
                            .background(Color(.init(red: 0, green: 0, blue: 1, alpha: 0.2)))
                    }
                    else {
                        locationListRow(loc)
                    }
                }
                .onMove(perform: moveLocation)
                .onDelete(perform: deleteLocation )
            }
            .toolbar {
                // ToolbarItemGroup(placement: .navigationBarLeading) {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    topButtons()
                }
            }
            .alert("Export JSON?", isPresented:$showingExportAlert) {
                exportAlertButtons()
            }
            .alert("Import JSON?", isPresented:$showingImportAlert) {
                importAlertButtons()
            }
        }
    }
    
    func topButtons() -> some View {
        Group {
            Button(action: { showingExportAlert = true } ) {
                Image(systemName: "square.and.arrow.up.on.square" )
            }
            Button(action: { showingImportAlert = true } ) {
                Image(systemName: "square.and.arrow.down.on.square" )
            }
            EditButton()
        }
    }

    func locationListHeader() -> some View {
        Group {
            Text("\(appModel.locations.count) Locations")
                .font(.caption)
            // .padding()
            HStack {
                Text("description:")
                    .font(.footnote)
                TextField("", text: $appModel.description)
                    .font(.footnote)
            }
            .padding(5)
        }
    }
    
    func locationListRow(_ loc: Location) -> some View {
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

    func exportAlertButtons() -> some View {
        Group {
            Button("Ok") {
                exportJSON();
                showingExportAlert = false
            }
            Button("Cancel", role: .cancel) {
                showingExportAlert = false
            }
        }
    }
    
    func importAlertButtons() -> some View {
        Group {
            Button("Ok") {
                importJSON();
                showingImportAlert = false
            }
            Button("Cancel", role: .cancel) {
                showingImportAlert = false
            }
        }
    }
    
    // --
    
    func exportJSON() {
        print("exportJSON string")
        let pasteboard = UIPasteboard.general
        pasteboard.string = appModel.settingsAsJSON()
    }
    
    func importJSON() {
        let pasteboard = UIPasteboard.general
        if let string = pasteboard.string {
            // text was found and placed in the "string" constant
            print("importJSON", string)
            appModel.settingsFromJSON(string);
        }
        else {
            print("importJSON no string")
        }
    }

    func moveLocation(from source: IndexSet, to destination: Int) {
        //print("FlagMarkedView moveLocation", source, destination)
        appModel.moveLocation(from: source, to: destination)
    }
    
    func deleteLocation( indices: IndexSet) {
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
