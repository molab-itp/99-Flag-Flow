//
//  MainView.swift
//  EarthFlags
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI

enum TabTag {
    case flags
    case marks
    case detail
    case earth
    case map
}

struct MainTabView: View {
    
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var locationModel: LocationModel

    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            FlagListView()
                .tabItem {
                    Label("Flags", systemImage: "list.bullet")
                }
                .tag(TabTag.flags)
            FlagMarkedView(marked: appModel.marked())
                .tabItem {
                    Label("Marked", systemImage: "circle.fill")
                }
                .tag(TabTag.marks)
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
            FlagWebView()
                .tabItem {
                    Label("Detail", systemImage: "info.circle")
                }
                .tag(TabTag.detail)
        }
        .onAppear() {
            // print("MainTabView onAppear appModel.settings.locations", appModel.settings.locations)
            // print("MainTabView onAppear locationModel.locations", locationModel.locations)
             appModel.restoreLocations()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppModel.sample)
        .environmentObject(LocationModel.sample)
}

// "https://en.wikipedia.org/wiki/Jamaica"
