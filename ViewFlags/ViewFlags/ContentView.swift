//
// UIImage named from Resource folder

import SwiftUI
import UIKit

struct ContentView: View {
    let fitems = Bundle.main.decode([FlagItem].self, from: "countries.json").shuffled()
    @State var country = "ALA"
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            
            List {
                ForEach(fitems, id: \.alpha3) { fitem in
                    VStack {
                        Image("flag-"+fitem.alpha3)
                            .resizable()
                            .frame(width: 200, height: 100)
                        Text(fitem.name)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//VStack {
//    Image("flag-ABW")
//        .resizable()
//        .frame(width: 200, height: 100)
//    Image("flag-AGO")
//        .resizable()
//        .frame(width: 200, height: 100)
//    Image("flag-"+fitems[1].alpha3)
//        .resizable()
//        .frame(width: 200, height: 100)
//}
