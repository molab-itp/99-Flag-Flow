//
//  ContentView.swift
//  SVGDemo
//
//  Created by jht2 on 11/10/23.
//

import SwiftUI
import SVGView

let url1 = "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg"
let url = "https://tisch.nyu.edu/content/dam/tisch/itp/Faculty/dan-osullivan1.jpg.preset.square.jpeg"
//let aname = "Flag_of_Jamaica";
//let aname = "pikachu";
let aname = "JAM";
let bname = "Flag_of_Jamaica";

struct ContentView: View {
    var body: some View {
//        let url = Bundle.main.url(forResource: bname, withExtension: "svg")
         let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg")
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            
            VStack {
                 Image(aname)
                     .resizable()
                     .frame(width: 100, height: 50)
                SVGView(contentsOf: url!)
//                    .resizable()
                    .frame(width: 100, height: 50)

                // AsyncImage(url: URL(string: url))
                // Image(systemName: "globe")
                // .imageScale(.large)
                // .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

struct ContentView_pikachu: View {
    var body: some View {
        let view = SVGView(contentsOf: Bundle.main.url(forResource: "pikachu", withExtension: "svg")!)
        let delta = CGAffineTransform(translationX: 50, y: 0)
        //        let delta = CGAffineTransform(translationX: getEyeX(), y: 0)
        view.getNode(byId: "eye1")?.transform = delta
        //        view.getNode(byId: "eye2")?.transform = delta
        if let part = view.getNode(byId: "eye1") {
            print("eye1 found")
            part.opacity = 0.2
        }
        else {
            print("no eye1")
        }
        return view
        //        return view.gesture(DragGesture().onChanged { g in
        //            self.x = g.location.x
        //        })
    }
    //    func getEyeX() ->
}

#Preview {
    ContentView()
    //    ContentView_pikachu()
}
