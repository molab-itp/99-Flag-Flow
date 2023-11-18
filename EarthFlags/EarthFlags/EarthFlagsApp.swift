// # ViewFlags

import SwiftUI

@main
struct EarthFlagsApp: App {
    var body: some Scene {
        WindowGroup {
            // This is the starting page for the app
            MainTabView()
                .environmentObject(Model())
        }
    }
}
