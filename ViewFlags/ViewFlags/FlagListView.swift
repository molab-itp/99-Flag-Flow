//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let titleRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/ViewFlags"

struct FlagListView: View {

    @EnvironmentObject var model: Model
    @Environment(\.openURL) var openURL
    
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
                List {
                    ForEach(model.flagItems, id: \.alpha3) { fitem in
                        FlagItemRowView(flagItem: fitem)
                    }
                }
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
