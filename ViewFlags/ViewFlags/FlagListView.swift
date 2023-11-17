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
                        VStack {
                            Image("flag-"+fitem.alpha3)
                                .resizable()
                                .frame(width: 200, height: 100)
                                .onTapGesture {
                                    print("tapped", fitem)
                                    model.flagItem = fitem
                                    model.selectedTab = .detail
                                }
                            HStack {
                                Text(fitem.label())
                                Spacer()
                                Link(destination: fitem.wikiUrlFor()!) {
                                    Image(systemName: "safari")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FlagListView()
        .environmentObject(Model())
}
