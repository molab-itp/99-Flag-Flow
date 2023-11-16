//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let titleRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/ViewFlags"

struct FlagListView: View {
    
    @Environment(\.openURL) var openURL
    
    let fitems = getCountriesFromJSON()
    
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
                    ForEach(fitems, id: \.alpha3) { fitem in
                        VStack {
                            Image("flag-"+fitem.alpha3)
                                .resizable()
                                .frame(width: 200, height: 100)
                                .onTapGesture {
                                    print("tapped", fitem)
                                }
                            HStack {
                                Text(label(fitem: fitem))
                                Spacer()
                                Link(destination: wikiUrlFor(fitem)!) {
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

func wikiUrlFor(_ fitem:FlagItem) -> URL? {
    URL(string: "https://en.wikipedia.org" + fitem.url)
}

func getCountriesFromJSON() -> [FlagItem] {
    var flags = Bundle.main.decode([FlagItem].self, from: "countries.json")
    flags = flags.sorted { $0.alpha3 < $1.alpha3 }
    for index in 0..<flags.count {
        flags[index].index = index+1;
    }
    return flags
}

func label(fitem: FlagItem) -> String {
    let sindex = fitem.index ?? 0
    return "\(sindex) \(fitem.alpha3) \(fitem.name)"
}

#Preview {
    FlagListView()
}
