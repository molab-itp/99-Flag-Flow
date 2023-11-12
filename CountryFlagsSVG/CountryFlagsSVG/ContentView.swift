//
//  ContentView.swift
//  SVGDemo
//
//  Created by jht2 on 11/10/23.
//

import SwiftUI
import SVGView

//let aname = "Flag_of_Jamaica";
//let aname = "pikachu";
let aname = "JAM";
let strRef = "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg";
//let strRef = "https://jht1493.net/external_media/country-svg/JAM.svg";

struct ContentView: View {
    var body: some View {
        // let url = Bundle.main.url(forResource: bname, withExtension: "svg")
        let url = URL(string: strRef)
        @State var data: Data?
        
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            
            VStack {
//                Image(aname)
//                    .resizable()
//                    .frame(width: 100, height: 50)
//                SVGView(contentsOf: url!)
//                    .frame(width: 100, height: 50)
                if let data {
                    SVGView(data: data)
                        .frame(width: 100, height: 50)
                }
                Text("Hello, world!")
            }
            .padding()
        }
        .task {
            print("task data before", data ?? "-none-")
            data = await asyncDataFor(url: strRef)
            print("task data after", data ?? "-none-")
        }
    }
}

#Preview {
    ContentView()
    //    ContentView_pikachu()
}
