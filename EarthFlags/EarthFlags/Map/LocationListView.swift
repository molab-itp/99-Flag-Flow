//
//  LocationListView.swift
//  EarthFlags
//

import SwiftUI

struct LocationListView: View {
    
//    var marked: [FlagItem]

    @EnvironmentObject var model: LocationModel

//    @State private var showingUnmarkAlert: Bool = false
//    @State private var unmarkFlagItem: FlagItem?
    

    var body: some View {
        VStack {
            Text("\(model.locations.count) Locations")
                .font(.caption)
                .padding()
            List {
                ForEach(model.locations) { loc in
//                    FlagMarkedRowView(flagItem: fitem,
//                                      showUnmarkAlert: $showingUnmarkAlert,
//                                      unmarkFlagItem: $unmarkFlagItem)
                    Text(loc.label)
                }
                .onMove(perform: move)
                .onDelete(perform: delete )
            }
            .toolbar {
                EditButton()
            }
        }
//        .alert("Remove flag from marked list?", isPresented:$showingUnmarkAlert) {
//            Button("Unmark Flag") {
//                if let unmarkFlagItem {
//                    withAnimation {
//                        model.setMarked(flagItem: unmarkFlagItem, state: false);
//                    }
//                }
//                showingUnmarkAlert = false
//            }
//            Button("Cancel", role: .cancel) {
//                showingUnmarkAlert = false
//            }
//        }
    }
    func move(from source: IndexSet, to destination: Int) {
        //print("FlagMarkedView move", source, destination)
//        model.markedMove(from: source, to: destination)
    }
    func delete( indices: IndexSet) {
        //print("onDelete", indices)
        withAnimation {
//            model.markedDelete(indices: indices)
        }
    }
    
}

#Preview {
    LocationListView()
        .environmentObject(LocationModel.sample)
}
