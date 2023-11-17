//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let titleRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/ViewFlags"

struct FlagListView: View {
    
    @EnvironmentObject var model: Model
    @Environment(\.openURL) var openURL
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            VStack {
                Link("FlagList",
                     destination: URL(string: titleRef)!)
                // .font(.largeTitle)
                .padding()
                NavigationStack {
                    List {
                        ForEach(searchResults, id: \.alpha3) { fitem in
                            FlagItemRowView(flagItem: fitem)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [FlagItem] {
        if searchText.isEmpty {
            return model.flagItems
        } else {
            return model.flagItems.filter { $0.name.contains(searchText) }
        }
    }

}

struct FlagItemRowView: View {
    @EnvironmentObject var model: Model
    var flagItem:FlagItem
    var body: some View {
        VStack {
            Image("flag-"+flagItem.alpha3)
                .resizable()
                .frame(width: 200, height: 100)
                .onTapGesture {
                    print("tapped", flagItem)
                    model.flagItem = flagItem
                    model.selectedTab = .detail
                }
            HStack {
                Text(flagItem.label())
                Spacer()
                Link(destination: flagItem.wikiUrl()!) {
                    Image(systemName: "safari")
                }
            }
        }
    }
}

#Preview {
    FlagListView()
        .environmentObject(Model.example)
}
