//
//  AppModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/16/23.
//

import Foundation
import WebKit

class AppModel: ObservableObject
{
    @Published var selectedTab = TabTag.flags
    @Published var flagItem: FlagItem?
    @Published var flagItems: [FlagItem]
    var flagDict: Dictionary<String,FlagItem>
    
    @Published var settings:Settings

    var webView:WKWebView?
    
    static let main = AppModel()
    
    lazy var verNum = Self.bundleVersion()

    init() {
        settings = AppModel.loadSettings()
        flagItems = getCountriesFromJSON()
        flagDict = Dictionary<String,FlagItem>()
        for flag in flagItems {
            flagDict[flag.alpha3] = flag;
        }
    }
    
    static var sample:AppModel {
        let model = AppModel();
        model.flagItem = model.flagItems[107] // JAM
        return model
    }
    
    var locations: [Location] {
        settings.locations
    }
    
    func addLocation(loc: Location, after: Int) {
        print("AppModel addLocation after", after)
        //settings.locations.append(loc)
        settings.locations.insert(loc, at: after+1)
        saveSettings();
    }
    
    func moveLocation(from source: IndexSet, to destination: Int) {
        print("AppModel moveLocation", source, destination)
        settings.locations.move(fromOffsets: source, toOffset: destination)
        saveSettings();
    }
    
    func deleteLocation(indices: IndexSet) {
        print("AppModel deleteLocation", indices)
        settings.locations.remove(atOffsets: indices)
        saveSettings();
    }

    func restoreLocations() {
        if let loc = settings.locations.first {
            LocationModel.main.setLocation(loc)
        }
    }
    
    func flagItem(ccode:String) -> FlagItem? {
        return flagDict[ccode]
    }
    
    func currentFlagItem(_ ccode: String) {
        flagItem = flagItem(ccode: ccode);
    }
    
    func isMarked(flagItem: FlagItem) -> Bool {
        settings.marked.contains(flagItem.alpha3)
    }
    
    func toggleMarked(flagItem: FlagItem) {
        let state = isMarked(flagItem: flagItem);
        setMarked(flagItem: flagItem, state: !state)
    }
    
    func setMarked(flagItem: FlagItem, state: Bool) {
        // print("setFavorite state", state)
        // check if already marked
        if let index = settings.marked.firstIndex(of:flagItem.alpha3) {
            // Currently marked
            if state { return }
            settings.marked.remove(at:index);
            // Remove all locations that match the country code
//            settings.locations = settings.locations.filter {
//                $0.ccode != flagItem.alpha3
//            }
        }
        else {
            // Not currently marked
            if !state { return }
            settings.marked.append(flagItem.alpha3)
            // First appearance of this country in locations
            let loc = Location( id: flagItem.uuidString,
                                ccode: flagItem.alpha3,
                                latitude: flagItem.latitude,
                                longitude: flagItem.longitude,
                                label: flagItem.name,
                                capital: flagItem.capital);
            settings.locations.append(loc)
            
        }
        saveSettings();
    }
    
    func marked() -> [FlagItem] {
        // Return the flag items in the order that they appear in settings.marked
        return settings.marked.compactMap { flagItem(ccode: $0) }
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
    var flags = Bundle.main.decode([FlagItem].self, from: "countries_capitals.json")
//    flags = flags.sorted { $0.alpha3 < $1.alpha3 }
    for index in 0..<flags.count {
        flags[index].index = index+1;
    }
    return flags
}


// load and save settings
//
extension AppModel {
    
    static let savePathRead = FileManager.documentsDirectory.appendingPathComponent("AppSetting.json")
    static let savePathSave = FileManager.documentsDirectory.appendingPathComponent("AppSetting.json")

    static func loadSettings() -> Settings {
        print("AppModel loadSettings")

        var settings:Settings;
        do {
            let data = try Data(contentsOf: Self.savePathRead)
            settings = try JSONDecoder().decode(Settings.self, from: data)
            if settings.version != currentVersion {
                print("AppModel loadSettings version wrong ", settings.version, currentVersion)
                settings = Settings();
            }
        } catch {
            print("AppModel loadSettings error", error)
            settings = Settings();
        }
                
        return settings;
    }
    
//    func restoreLocations() {
//        LocationModel.main.restoreFrom(marked: settings.marked)
//    }
    
    func saveSettings() {
        print("AppModel saveSettings", settings)
        print("AppModel saveSettings marked", settings.marked)
        print("AppModel saveSettings locations", settings.locations)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(settings)
            try data.write(to: Self.savePathSave, options: [.atomic, .completeFileProtection])
        } catch {
            print("AppModel saveSettings error", error)
        }
        // restoreLocations();
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

let currentVersion = 2;

// Must be a struct Settings for edits to register
struct Settings: Codable {

    var version: Int = currentVersion
    
    var marked: Array<String> = [];
    
    var locations: [Location] = []
    
}

// https://developer.apple.com/documentation/swiftui/observedobject

