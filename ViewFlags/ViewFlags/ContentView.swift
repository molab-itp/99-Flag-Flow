//
// UIImage named from Resource folder

import SwiftUI
import UIKit

struct ContentView: View {
    let fitems = Bundle.main.decode([FlagItem].self, from: "countries.json")
    @State var country = "ALA"
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            
            VStack {
                Image("flag-ALA")
                    .resizable()
                    .frame(width: 200, height: 100)
                Image("flag-AFG")
                    .resizable()
                    .frame(width: 200, height: 100)
                //            Image("flag-"+fitems[1].alpha3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

