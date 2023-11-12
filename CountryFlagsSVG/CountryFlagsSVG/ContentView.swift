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
    
//    @State var data: Data?
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            
            VStack {
                SVGViewAsync(strRef: strRef)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

struct SVGViewAsync: View {
    var strRef: String
    @State var data: Data?
    
    var body: some View {
        VStack {
            if let data = data {
                SVGView(data: data)
                    .frame(width: 100, height: 50)
            }
        }
        .task {
            // print("task data before", data ?? "-none-")
            data = await asyncDataFor(url: strRef)
            print("task data after", data ?? "-none-")
        }
    }
}

#Preview {
    ContentView()
    //    ContentView_pikachu()
}
