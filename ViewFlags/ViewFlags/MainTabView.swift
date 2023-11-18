//
//  MainView.swift
//  ViewFlags
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI

enum TabTag {
    case list
    case favs
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
            FlagMarkedView()
                .tabItem {
                    Label("Marked", systemImage: "circle.fill")
                }
                .tag(TabTag.favs)
            FlagWebView()
                .tabItem {
                    Label("Detail", systemImage: "info.circle")
                }
                .tag(TabTag.detail)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(Model.example)
}

// "https://en.wikipedia.org/wiki/Jamaica"
