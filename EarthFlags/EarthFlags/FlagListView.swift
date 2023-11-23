//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let titleRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/EarthFlags"

struct FlagListView: View {
    
    @EnvironmentObject var model: AppModel
    
    @State private var searchText = ""
    
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .background(Color(white: 0.9))
                    .foregroundStyle(Color(white: 0.8))
                VStack {
                    //Link("Earth Flags",
                    //     destination: URL(string: titleRef)!)
                    // .font(.largeTitle)
                    // .padding()
                    Text("\(model.flagItems.count) Countries on Earth")
                        .padding()
                    
                    List {
                        ForEach(searchResults, id: \.alpha3) { fitem in
                            FlagItemRowView(flagItem: fitem)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { 
                        if let url = URL(string: titleRef) {
                            openURL(url)
                        }
                    } ) {
                        Image(systemName: "safari" )
                    }
                }
            }
            .searchable(text: $searchText)
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

struct FlagItemRowView: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var locationModel: LocationModel
    var flagItem:FlagItem
    var body: some View {
        VStack {
            Image("flag-"+flagItem.alpha3)
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
//                Button {
//                    model.flagItem = flagItem
//                    model.selectedTab = .detail
//                } label: {
//                    // let state = model.isMarked(flagItem: flagItem)
//                    Image(systemName: "info.circle")
//                }
//                Spacer()
                Text(flagItem.label())
                Spacer()
                Button {
                    Task {
                        withAnimation {
                            model.toggleMarked(flagItem: flagItem);
                            if model.isMarked(flagItem: flagItem) {
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
