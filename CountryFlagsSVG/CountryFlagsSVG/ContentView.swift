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
                    CountryFlagView(code: "JAM", width: 300, height: 240, data: dataFor(country: "JAM"))
// CountryFlagView(code: "GUY", width: 300, height: 240, data: dataFor(country: "GUY"))
// CountryFlagView(code: "USA", width: 300, height: 240, data: dataFor(country: "USA"))
//                    SVGViewAsync(strRef: strRef, width: 300, height: 240)
//                    SVGViewAsync(strRef: strRef1)
//                    SVGViewAsync(strRef: strRef2)
                    Text("Hello, world!")
                }
                ForEach(fitems, id: \.alpha3) { fitem in
                    VStack {
                        CountryFlagView(code: fitem.alpha3, width: 300, height: 240, data: dataFor(country: fitem.alpha3))
//                        SVGViewAsync(strRef: "https:"+fitem.file_url, label: label(fitem: fitem)  )
                        HStack {
                            Text( label(fitem: fitem) + " "+fitem.name)
                            Spacer()
                        }
                    }
                }
            }

        }
        .onAppear {
            // print("fitems", fitems)
            print("fitems.count", fitems.count)
            // print("JAM", urlFor(country: "JAM"))
        }
    }
}

// load svg in bundle into a SVGView
struct CountryFlagView: View {
    var code: String
    var width: CGFloat = 300
    var height: CGFloat = 200
    var label: String = ""
    var data: Data?
    var body: some View {
        VStack {
            if let data {
                SVGView(data: data)
                    .frame(width: width, height: height)
            }
        }
//        .onAppear() {
//            let url = urlFor(country: code);
//            data = dataFor(url: url)
//            // print("task data after", data ?? "-none-")
//            print("ViewCountry url", label, url)
//        }
    }
}

func dataFor(country: String) -> Data? {
    dataFor(url: urlFor(country: country))
}

func urlFor(country: String) -> URL {
    let appPath = Bundle.main.bundlePath
    var url = URL(fileURLWithPath: appPath)
    url.appendPathComponent("flags-svg/\(country).svg", isDirectory: false)
    return url;
}

func label(fitem: FlagItem) -> String {
    String(fitem.index ?? 0) + " " + fitem.alpha3
}

func getCountriesFromJSON() -> [FlagItem] {
    var flags = Bundle.main.decode([FlagItem].self, from: "countries.json")
//    flags = flags.shuffled();
    for index in 0..<flags.count {
        flags[index].index = index;
    }
    return flags
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
