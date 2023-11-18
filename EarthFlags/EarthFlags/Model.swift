//
//  Model.swift
//  ViewFlags
//
//  Created by jht2 on 11/16/23.
//

import Foundation

class Model: ObservableObject
{
    @Published var selectedTab = TabTag.list
    @Published var flagItem: FlagItem?
    @Published var flagItems = getCountriesFromJSON()

    @Published var settings:Settings = Model.loadSettings()

    @Published var mapRegion = MapRegionModel()

    static var example:Model {
        let model = Model();
        model.flagItem = model.flagItems[107] // JAM
        return model
    }
    
    
    func isMarked(flagItem: FlagItem) -> Bool {
        settings.marked.contains(flagItem.alpha3)
    }
    
    func toggleMarked(flagItem: FlagItem) {
        let state = isMarked(flagItem: flagItem);
        setMarked(flagItem: flagItem, state: !state)
        saveSettings();
    }
    
    func setMarked(flagItem: FlagItem, state: Bool) {
        // print("setFavorite state", state)
        if state {
            settings.marked.insert(flagItem.alpha3)
        }
        else {
            settings.marked.remove(flagItem.alpha3)
        }
    }
    
    func marked() -> [FlagItem] {
        flagItems.filter {
            isMarked(flagItem: $0)
        }
    }
}

func getCountriesFromJSON() -> [FlagItem] {
    var flags = Bundle.main.decode([FlagItem].self, from: "countries.json")
    flags = flags.sorted { $0.alpha3 < $1.alpha3 }
    for index in 0..<flags.count {
        flags[index].index = index+1;
    }
    return flags
}

// load and save settings
//
extension Model {
    
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("AppSetting")
    
    static func loadSettings() -> Settings {
        var settings:Settings;
        do {
            let data = try Data(contentsOf: Self.savePath)
            settings = try JSONDecoder().decode(Settings.self, from: data)
        } catch {
            print("AppModel loadSettings error", error)
            settings = Settings();
        }
        return settings;
    }
    
    func saveSettings() {
        // print("saveSettings", settings)
        do {
            let data = try JSONEncoder().encode(settings)
            try data.write(to: Self.savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("AppModel saveSettings error", error)
        }
    }
    
    static func bundleVersion() -> String {
        return String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)
    }
    
} // extension AppModel

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
} // extension FileManager

// https://github.com/twostraws/HackingWithSwift.git
//  SwiftUI/project14/Bucketlist/ContentView-ViewModel.swift
// https://github.com/twostraws/HackingWithSwift/blob/main/SwiftUI/project14/Bucketlist/ContentView-ViewModel.swift

struct Settings: Codable {
    
    var marked: Set<String> = [];
}

