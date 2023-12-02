//
//  Settings.swift
//  EarthFlags
//
//  Created by jht2 on 12/2/23.
//

import Foundation

// Must be a struct Settings for edits to register
struct Settings: Codable {
    
    var description: String? = "My flags"
    
    var selectedTab: TabTag?
    
    var version: Int = currentVersion
    
    var marked: Array<String> = [];
    
    var locations: [Location] = []
    
}

enum TabTag: String, Codable {
    case flags
    case marks
    case detail
    case earth
    case map
}

// Increase currentVerion code to invalidate old formats
let currentVersion = 3;

