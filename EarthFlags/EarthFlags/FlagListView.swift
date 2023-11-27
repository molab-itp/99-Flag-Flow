//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let titleRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/EarthFlags"

struct FlagListView: View {
    
    @EnvironmentObject var model: AppModel
    @Environment(\.openURL) private var openURL

    @State private var searchText = ""

    @State private var showingUnmarkAlert: Bool = false
    @State private var unmarkFlagItem: FlagItem?

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .background(Color(white: 0.9))
                    .foregroundStyle(Color(white: 0.8))
                VStack {
                    countRow()
                    List {
                        // countBar()
                        ForEach(searchResults, id: \.alpha3) { fitem in
                            FlagListRowView(flagItem: fitem,
                                            showUnmarkAlert: $showingUnmarkAlert,
                                            unmarkFlagItem: $unmarkFlagItem)
                        }
                    }
                    .navigationTitle("EarthFlags v\(model.verNum)")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement:
                                .navigationBarTrailing) {
                            toolBarButtonRow()
                        }
                    }
                }
            }
            .searchable(text: $searchText)
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
    
    func toolBarButtonRow() -> some View {
        Button(action: {
            if let url = URL(string: titleRef) {
                openURL(url)
            }
        } ) {
            Image(systemName: "safari" )
        }
    }
    
    func countRow() -> some View {
        Group() {
            if searchText.isEmpty {
                Text("\(model.flagItems.count) Countries on Earth")
                    .font(.caption)
                    .padding()
                    //.padding([.top, .bottom], 10)
            }
            else {
                Text("\(searchResults.count) found")
                    .font(.caption)
                    .padding()
            }
        }
    }
    
    var searchResults: [FlagItem] {
        if searchText.isEmpty {
            return model.flagItems
        } else {
            return model.flagItems.filter {
                let stext = searchText.lowercased()
                let name = $0.name.lowercased()
                let alpha3 = $0.alpha3.lowercased()
                return name.contains(stext) || alpha3.contains(stext)
            }
        }
    }

}

struct FlagListRowView: View {
    
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
                                model.selectedTab = .marks
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
    FlagListView()
        .environmentObject(AppModel.sample)
}
