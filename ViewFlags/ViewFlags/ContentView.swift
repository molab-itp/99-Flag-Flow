//
// - view flags stored as jpg in Assets.xcassets


import SwiftUI
import UIKit

let urlRef = "https://github.com/molab-itp/99-Flag-Flow/tree/main/ViewFlags"

struct ContentView: View {
    
    @Environment(\.openURL) var openURL

    let fitems = getCountriesFromJSON()

    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            VStack {
                if let url = URL(string: urlRef) {
                    Link("ViewFlags",
                         destination: url)
                    // .font(.largeTitle)
                    .padding()
                }
                List {
                    ForEach(fitems, id: \.alpha3) { fitem in
                        VStack {
                            Image("flag-"+fitem.alpha3)
                                .resizable()
                                .frame(width: 200, height: 100)
                            Link(destination: wikiUrlFor(fitem)!) {
                                HStack {
                                    Text(label(fitem: fitem))
                                    Spacer()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
