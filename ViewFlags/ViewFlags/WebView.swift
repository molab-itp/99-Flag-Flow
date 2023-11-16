//
//  WebView.swift
//  ViewFlags
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI
import WebKit

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

#Preview {
    WebView(url: "https://apple.com")
}


// https://github.com/molab-itp/WebViewDemo.git
// https://developer.apple.com/forums/thread/117348
// https://medium.com/devtechie/webview-in-swiftui-a9c283f29327
