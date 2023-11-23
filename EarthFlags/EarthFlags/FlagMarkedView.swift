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
                                FlagItemRowView(flagItem: fitem)
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

#Preview {
    FlagMarkedView(marked: AppModel.sample.marked())
        .environmentObject(AppModel.sample)
}

//https://github.com/molab-itp/09-Bucketlist
//https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-move-rows-in-a-list
