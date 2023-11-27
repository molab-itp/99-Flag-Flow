//
//  FlagMarkedView.swift
//  EarthFlags
//
//  Created by jht2 on 11/17/23.
//

import SwiftUI

struct FlagMarkedView: View {
    
    var marked: [FlagItem]

    @EnvironmentObject var model: AppModel

    @State private var showingUnmarkAlert: Bool = false
    @State private var unmarkFlagItem: FlagItem?
    

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .background(Color(white: 0.9))
                    .foregroundStyle(Color(white: 0.8))
                ScrollViewReader { proxy in
                    VStack {
                        Text("\(marked.count) Marked")
                            .font(.caption)
                            .padding()
                        List {
                            ForEach(marked, id: \.alpha3) { fitem in
                                FlagMarkedRowView(flagItem: fitem,
                                                showUnmarkAlert: $showingUnmarkAlert,
                                                unmarkFlagItem: $unmarkFlagItem)

                            }
                            .onMove(perform: move)
                            .onDelete(perform: delete )
                        }
                        .toolbar {
                            EditButton()
                        }
                    }
                    .onAppear {
                        //print("FlagMarkedView ScrollViewReader onAppear marked", marked.count);
                        //print("FlagMarkedView ScrollViewReader settings.last", model.settings.marked.last!)
                        guard let last = marked.last else { return }
                        //print("FlagMarkedView ScrollViewReader last.alpha3", last.alpha3);
                        proxy.scrollTo(last.alpha3, anchor: .bottom)
                    }
                    .alert("Remove flag from marked list?", isPresented:$showingUnmarkAlert) {
                        Button("Unmark Flag") {
                            if let unmarkFlagItem {
                                withAnimation {
                                    model.setMarked(flagItem: unmarkFlagItem, state: false);
                                }
                            }
                            showingUnmarkAlert = false
                        }
                        Button("Cancel", role: .cancel) {
                            showingUnmarkAlert = false
                        }
                    }
                }
            }
        }
        .onAppear {
            //print("FlagMarkedView onAppear");
        }
        .onDisappear {
            //print("FlagMarkedView onDisappear")
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        //print("FlagMarkedView move", source, destination)
        model.markedMove(from: source, to: destination)
    }
    func delete( indices: IndexSet) {
        //print("onDelete", indices)
        withAnimation {
            model.markedDelete(indices: indices)
        }
    }
    
}

struct FlagMarkedRowView: View {
    
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var locationModel: LocationModel
    
    var flagItem: FlagItem
    
    @Binding var showUnmarkAlert: Bool
    @Binding var unmarkFlagItem: FlagItem?
    
    var body: some View {
        VStack {
            Image(flagItem.imageRef)
                .resizable()
                .frame(width: 200, height: 100)
                .onTapGesture {
                    // print("tapped", flagItem)
                    Task {
                        model.flagItem = flagItem
                        model.setMarked(flagItem: flagItem, state: true);
                        locationModel.setLocation(ccode: flagItem.alpha3)
                        model.selectedTab = .map
                    }
                }
            HStack {
                Text(flagItem.label())
                Spacer()
                Button {
                    if model.isMarked(flagItem: flagItem) {
                        // Is marked, will remove mark
                        unmarkFlagItem = flagItem
                        showUnmarkAlert = true
                    }
                    else {
                        // Not marked, now marked
                        Task {
                            withAnimation {
                                model.setMarked(flagItem: flagItem, state: true);
                            }
                        }
                    }
                } label: {
                    let state = model.isMarked(flagItem: flagItem)
                    Image(systemName: state ? "circle.fill" : "circle")
                }
            }
        }
    }
}

#Preview {
    FlagMarkedView(marked: AppModel.sample.marked())
        .environmentObject(AppModel.sample)
}

//https://github.com/molab-itp/09-Bucketlist
//https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-move-rows-in-a-list
