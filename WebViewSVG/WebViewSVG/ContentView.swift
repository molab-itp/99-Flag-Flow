//
//  ContentView.swift
//  WebKitDemo
//
//  Created by jht2 on 3/28/23.
//

import SwiftUI
import WebKit

let urls = ["https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg",
            "https://upload.wikimedia.org/wikipedia/commons/9/99/Flag_of_Guyana.svg",
            "https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg",
            "https://upload.wikimedia.org/wikipedia/commons/5/52/Flag_of_%C3%85land.svg",
            "https://upload.wikimedia.org/wikipedia/commons/6/6a/Flag_of_Zimbabwe.svg",
            "https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_the_Taliban.svg",
            "https://www.apple.com",
            "https://itp.nyu.edu",
]
let url = urls[0];

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            // .foregroundColor(.init(hue: 0.1, saturation: 0.1, brightness: 0.4))
            List {
                // Text("Hello")
                // WebView(url: urls[0])
                // .frame(width:400,height:200)
                ForEach(0 ..< urls.count, id: \.self) { index in
                    WebView(url: urls[index])
                        .frame(width:380,height:240)
                }
//                WebView(url: urls[1])
//                    .frame(width:380,height:240)
//                WebView(url: urls[4])
//                    .frame(width:380,height:220)

                // .frame(maxWidth: 400)
                // Text("Hello")
                // WebView(url: url)
                // Text("Hello")
                // WebView(url: url)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WebView : UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView  {
        // frame does not appear to affect
        // return WKWebView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let nurl = URL(string: url)
        guard let nurl = nurl else {
            print("URL failed url", url)
            return;
        }
        uiView.load(URLRequest(url: nurl))
    }
    
}

// https://developer.apple.com/forums/thread/117348

// https://medium.com/devtechie/webview-in-swiftui-a9c283f29327

// flag svg link source:
// https://github.com/linssen/country-flag-icons/blob/master/countries.json

