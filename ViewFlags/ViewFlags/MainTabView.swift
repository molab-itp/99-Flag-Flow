//
//  MainView.swift
//  ViewFlags
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI

enum TabTag {
    case list
    case detail
}

struct MainTabView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        TabView(selection: $model.selectedTab) {
            FlagListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(TabTag.list)
            FlagWebView()
                .tabItem {
                    Label("Detail", systemImage: "info.circle")
                }
                .tag(TabTag.detail)
        }
    }
}

struct FlagWebView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        if let fitem = model.flagItem {
            WebView(url: "https://en.wikipedia.org"+fitem.url);
        }
        else {
            EmptyView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(Model())
}

// "https://en.wikipedia.org/wiki/Jamaica"
