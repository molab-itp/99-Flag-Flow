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
    
    @Published var settings: Settings
    @Published var description: String = ""

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
        if let description = settings.description {
            self.description = description
        }
    }
    
    static var sample:AppModel {
        let model = AppModel();
        model.flagItem = model.flagItems[107] // JAM
        return model
    }
    
    // --
    
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
        if let loc = settings.locations.last {
            LocationModel.main.setLocation(loc)
        }
    }
    
    // --
    
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

// Read countries_capitals.json from Resources
func getCountriesFromJSON() -> [FlagItem] {
    var flags = Bundle.main.decode([FlagItem].self, from: "countries_capitals.json")
    for index in 0..<flags.count {
        flags[index].index = index+1;
    }
    return flags
}


// load and save settings
//
extension AppModel {
    
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("AppSetting.json")

    static func loadSettings() -> Settings {
        //print("AppModel loadSettings")
        var settings:Settings;
        do {
            let data = try Data(contentsOf: Self.savePath)
            settings = try JSONDecoder().decode(Settings.self, from: data)
            if settings.version != currentVersion {
                print("AppModel loadSettings version wrong ", settings.version, currentVersion)
                settings = Settings();
            }
        } catch {
            print("AppModel loadSettings error", error)
            settings = Settings();
        }
        print("AppModel loadSettings", settings.description ?? "-nil-", settings.marked.count, settings.locations.count)
        return settings;
    }
        
    func saveSettings() {
        print("AppModel saveSettings", settings.description ?? "-nil-", settings.marked.count, settings.locations.count)
        //print("AppModel saveSettings", settings)
        //print("AppModel saveSettings marked", settings.marked)
        //print("AppModel saveSettings locations", settings.locations)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(settings)
            try data.write(to: Self.savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("AppModel saveSettings error", error)
        }
    }
    
    // Exporting will set settings.description from description
    // and save locally
    func settingsAsJSON() -> String {
        var str = ""
        do {
            settings.description = description
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(settings)
            // str = String(data.description.utf8)
            // https://www.hackingwithswift.com/example-code/language/how-to-convert-data-to-a-string
            str = String(decoding: data, as: UTF8.self)
        } catch {
            print("AppModel settingsAsJSON error", error)
        }
        saveSettings();
        return str;
    }
    
    // Importing will set description from settings.description
    func settingsFromJSON(_ str: String) {
        var settings:Settings;
        do {
            // https://www.hackingwithswift.com/example-code/language/how-to-convert-a-string-to-data
            let data = Data(str.utf8)
            settings = try JSONDecoder().decode(Settings.self, from: data)
            if settings.version != currentVersion {
                print("AppModel settingsFromJSON version wrong ", settings.version, currentVersion)
            }
            if settings.description == nil {
                settings.description = Date().ISO8601Format()
            }
            self.settings = settings
            if let description = settings.description {
                self.description = description
            }
            saveSettings();
        } catch {
            print("AppModel settingsFromJSON error", error)
        }
    }
    
    static func bundleVersion() -> String {
        return String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)
    }
    
} // extension AppModel

// Increase currentVerion code to invalidate old formats
let currentVersion = 3;

// Must be a struct Settings for edits to register
struct Settings: Codable {

    var description: String? = "My flags"
    
    var version: Int = currentVersion
    
    var marked: Array<String> = [];
    
    var locations: [Location] = []
    
}

// https://developer.apple.com/documentation/swiftui/observedobject

// --

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
} // extension FileManager

// https://github.com/twostraws/HackingWithSwift.git
//  SwiftUI/project14/Bucketlist/ContentView-ViewModel.swift
// https://github.com/twostraws/HackingWithSwift/blob/main/SwiftUI/project14/Bucketlist/ContentView-ViewModel.swift


