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

struct MainView: View {
    var body: some View {
        TabView() {
            CountryListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(TabTag.list)
            WebView(url: "https://en.wikipedia.org/wiki/Jamaica")
                .tabItem {
                    Label("Detail", systemImage: "info.circle")
                }
                .tag(TabTag.detail)
        }
    }
}

#Preview {
    MainView()
}
