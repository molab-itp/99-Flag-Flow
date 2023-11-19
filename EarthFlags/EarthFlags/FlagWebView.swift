//
//  FlagWebView.swift
//  ViewFlags
//
//  Created by jht2 on 11/17/23.
//

import SwiftUI

struct FlagWebView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack {
            if let flagItem = model.flagItem {
                VStack {
                    Text(flagItem.label())
                        .font(.title)
                    
                    Image("flag-"+flagItem.alpha3)
                        .resizable()
                        .frame(width: 200, height: 100)
                }
                WebView(url: "https://en.wikipedia.org"+flagItem.url);
            }
            else {
                WebView(url: "https://en.wikipedia.org/wiki/Earth");
            }
        }
    }
}

#Preview {
    FlagWebView()
        .environmentObject(Model.sample)
}
