//
//  AppModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/16/23.
//

import Foundation

class AppModel: ObservableObject
{
    @Published var selectedTab = TabTag.list
    @Published var flagItem: FlagItem?
    @Published var flagItems = getCountriesFromJSON()

    @Published var settings:Settings

    static let main = AppModel()
    
    init() {
        settings = AppModel.loadSettings()
    }
    
    static var sample:AppModel {
        let model = AppModel();
        model.flagItem = model.flagItems[107] // JAM
        return model
    }
    
    func flagItem(ccode:String) -> FlagItem? {
        flagItems.first {
            $0.alpha3 == ccode
        }
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
        // remove flag if in marked
        if let index = settings.marked.firstIndex(of:flagItem.alpha3) {
            settings.marked.remove(at:index);
        }
        // Insert at begining
        if state {
            settings.marked.insert(flagItem.alpha3, at:0)
        }
    }
    
    func marked() -> [FlagItem] {
        // Return the flag items in the order that they appear in settings.marked
        return settings.marked.compactMap { mark in
            if let index = flagItems.firstIndex(where: { flag in
                flag.alpha3 == mark
            }) {
                return flagItems[index]
            }
            return nil;
        }
    }
    
    func markedMove(from source: IndexSet, to destination: Int) {
        print("markedMove", source, destination)
        settings.marked.move(fromOffsets: source, toOffset: destination)
        saveSettings();
    }
    
    func markedDelete(indices: IndexSet) {
        print("markedDelete", indices)
        settings.marked.remove(atOffsets: indices)
        saveSettings();
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
extension AppModel {
    
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("AppSetting")
    
    static func loadSettings() -> Settings {
        print("AppModel loadSettings")

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
    
    func restoreLocations() {
        Task() {
            await LocationModel.main.restoreFrom(marked: settings.marked)
        }
    }
    
    func saveSettings() {
        print("AppModel saveSettings", settings)
        do {
            let data = try JSONEncoder().encode(settings)
            try data.write(to: Self.savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("AppModel saveSettings error", error)
        }
        restoreLocations();
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
    
    var marked: Array<String> = [];
}

// https://developer.apple.com/documentation/swiftui/observedobject

