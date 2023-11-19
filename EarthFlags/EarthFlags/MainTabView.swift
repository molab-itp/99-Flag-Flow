//
//  MainView.swift
//  ViewFlags
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI

enum TabTag {
    case list
    case marks
    case detail
    case earth
    case map
}

struct MainTabView: View {
    
    @EnvironmentObject var model: AppModel
    
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
                .tag(TabTag.marks)
            FlagWebView()
                .tabItem {
                    Label("Detail", systemImage: "info.circle")
                }
                .tag(TabTag.detail)
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(TabTag.map)
            SwiftGlobeBridgeView()
                .tabItem {
                    Label("Earth", systemImage: "globe")
                }
                .tag(TabTag.earth)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppModel.sample)
        .environmentObject(LocationModel.sample)
}

// "https://en.wikipedia.org/wiki/Jamaica"
