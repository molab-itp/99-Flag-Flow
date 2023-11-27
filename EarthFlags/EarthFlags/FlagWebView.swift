//
//  FlagWebView.swift
//  EarthFlags
//
//  Created by jht2 on 11/17/23.
//

import SwiftUI

struct FlagWebView: View {
    
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack {
            if let flagItem = model.flagItem {
                VStack {
                    Link(destination: flagItem.wikiUrl()!) {
                        HStack {
                            Image(systemName: "safari")
                            Text(flagItem.label())
                                .font(.title)
                        }
                    }
                    Image(flagItem.imageRef)
                        .resizable()
                        .frame(width: 200, height: 100)
                        .onTapGesture {
                            if let webView = model.webView,
                               let url = URL(string: flagItem.url){
                                // webView.reload()
                                webView.load(URLRequest(url: url))
                            }
                        }
                }
                WebView(url: flagItem.url);
            }
            else {
                WebView(url: "https://en.wikipedia.org/wiki/Earth");
            }
        }
    }
}

#Preview {
    FlagWebView()
        .environmentObject(AppModel.sample)
}
