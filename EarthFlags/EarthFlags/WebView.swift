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
    
    @EnvironmentObject var model: AppModel

    func makeUIView(context: Context) -> WKWebView  {
        
        print("makeUIView url", url)

        // frame does not appear to affect
        // return WKWebView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let nwebView = WKWebView()
        
        model.webView = nwebView
        
        return nwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let nurl = URL(string: url) else {
            print("URL failed url", url)
            return;
        }
        uiView.load(URLRequest(url: nurl))
    }
    
}

#Preview {
    WebView(url: "https://apple.com")
        .environmentObject(AppModel.sample)
}

// ?? How to add button to reload

// https://developer.apple.com/documentation/webkit/wkwebview

// https://github.com/molab-itp/WebViewDemo.git
// https://developer.apple.com/forums/thread/117348
// https://medium.com/devtechie/webview-in-swiftui-a9c283f29327
