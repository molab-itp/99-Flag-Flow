//
//  FlagFavsView.swift
//  ViewFlags
//
//  Created by jht2 on 11/17/23.
//

import SwiftUI

struct FlagMarkedView: View {
    
    @State var marked: [FlagItem] = []
    
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .background(Color(white: 0.9))
                    .foregroundStyle(Color(white: 0.8))
                VStack {
                    // Query count from model to get modified count
                    Text("\(model.marked().count) Marked")
                        .padding()
                    List {
                        ForEach(marked, id: \.alpha3) { fitem in
                            FlagItemRowView(flagItem: fitem)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete )
                    }
                    .toolbar {
                        EditButton()
                    }
                }
            }
        }
        .onAppear {
            print("FlagMarkedView onAppear");
            // Capture marked here to so list not updated on marked status changed
            marked = model.marked();
        }
        .onDisappear {
            print("FlagMarkedView onDisappear")
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        print("FlagMarkedView move", source, destination)
        model.markedMove(from: source, to: destination)
        marked = model.marked();
        // users.move(fromOffsets: source, toOffset: destination)
    }
    func delete( indices: IndexSet) {
        print("onDelete", indices)
        model.markedDelete(indices: indices)
        marked = model.marked();
        // appModel.removeLocation(at: indices)
    }
    
}

#Preview {
    FlagMarkedView(marked: AppModel.sample.marked())
        .environmentObject(AppModel.sample)
}

//https://github.com/molab-itp/09-Bucketlist
//https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-move-rows-in-a-list
