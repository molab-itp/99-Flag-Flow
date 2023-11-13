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
            List {
                VStack {
                    SVGViewAsync(strRef: strRef, width: 300, height: 240)
                    SVGViewAsync(strRef: strRef1)
                    SVGViewAsync(strRef: strRef2)
                    Text("Hello, world!")
                }
                ForEach(fitems, id: \.alpha3) { fitem in
                    VStack {
                        SVGViewAsync(strRef: "https:"+fitem.file_url, label: fitem.alpha3 )
                        HStack {
                            Text(fitem.alpha3 + ": "+fitem.name)
                            Spacer()
                        }
                    }
                }
            }

        }
        .onAppear {
            // print("fitems", fitems)
            print("fitems.count", fitems.count)
        }
    }
}

func getCountriesFromJSON() -> [FlagItem] {
    return Bundle.main.decode([FlagItem].self, from: "countries.json")
     .shuffled();
}

/// Asyncronously load svg in a View
struct SVGViewAsync: View {
    var strRef: String
    var width: CGFloat = 300
    var height: CGFloat = 200
    var label: String = ""
    @State var data: Data?
    var body: some View {
        VStack {
            if let data {
                SVGView(data: data)
                    .frame(width: width, height: height)
            }
        }
        .task {
            data = await asyncDataFor(url: strRef)
            // print("task data after", data ?? "-none-")
            print("SVGViewAsync strRef", label, strRef)
        }
    }
}

#Preview {
    ContentView()
    //    ContentView_pikachu()
}
