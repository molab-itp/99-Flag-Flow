//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let titleRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/ViewFlags"

struct FlagListView: View {
    
    @EnvironmentObject var model: Model
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            VStack {
                Link("Earth Flags",
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
            return model.flagItems.filter {
                let stext = searchText.lowercased()
                let name = $0.name.lowercased()
                let alpha3 = $0.alpha3.lowercased()
                return name.contains(stext) || alpha3.contains(stext)
            }
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
                    // print("tapped", flagItem)
                    model.flagItem = flagItem
                    model.selectedTab = .detail
                }
            HStack {
                Text(flagItem.label())
                Spacer()
                Button {
                    Task {
                        model.toggleFavorite(flagItem: flagItem);
                    }
                } label: {
                    let state = model.isFavorite(flagItem: flagItem)
                    Image(systemName: state ? "heart.fill" : "heart")
                }
//                Spacer()
//                Link(destination: flagItem.wikiUrl()!) {
//                    Image(systemName: "safari")
//                }
            }
        }
    }
}

#Preview {
    FlagListView()
        .environmentObject(Model.example)
}
