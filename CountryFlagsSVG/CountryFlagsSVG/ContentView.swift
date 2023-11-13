//
//  ContentView.swift
//  SVGDemo
//
//  Created by jht2 on 11/10/23.
//

import SwiftUI
import SVGView

let strRef = "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg";
let strRef1 = "https://upload.wikimedia.org/wikipedia/commons/9/99/Flag_of_Guyana.svg"
let strRef2 = "https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg"

struct ContentView: View {
    let fitems = getCountriesFromJSON()
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
//            VStack {
//                SVGViewAsync(strRef: strRef)
//                SVGViewAsync(strRef: strRef1)
//                SVGViewAsync(strRef: strRef2)
//                Text("Hello, world!")
//            }
//            .padding()
            List {
                ForEach(fitems, id: \.alpha3) { fitem in
                    VStack {
                        SVGViewAsync(strRef: "https:"+fitem.file_url)
                        HStack {
                            Text(fitem.alpha3 + ": "+fitem.name)
                        }
                    }
                }
            }

        }
        .onAppear {
//            print("fitems", fitems)
            print("fitems.count", fitems.count)
        }
    }
}

func getCountriesFromJSON() -> [FlagItem] {
//    return [];
    return Bundle.main.decode([FlagItem].self, from: "countries.json") // .shuffled();
}

struct SVGViewAsync: View {
    var strRef: String
    @State var data: Data?
    var body: some View {
        VStack {
            if let data {
                SVGView(data: data)
                    .frame(width: 200, height: 100)
            }
        }
        .task {
            data = await asyncDataFor(url: strRef)
            // print("task data after", data ?? "-none-")
        }
    }
}

#Preview {
    ContentView()
    //    ContentView_pikachu()
}
