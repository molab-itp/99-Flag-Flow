//
//  FlagModel.swift
//  EarthFlags
//
//  Created by jht2 on 11/12/23.
//

import Foundation

//"JAM": {
//    "url": "https://en.wikipedia.org/wiki/Jamaica",
//    "alpha3": "JAM",
//    "name": "Jamaica",
//    "file_url": "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg",
//    "license": "Public domain",
//    "capital": "Kingston",
//    "latitude": 18,
//    "longitude": -76.48
//},

struct FlagItem : Decodable {
    var url: String;
    var alpha3: String;
    var name: String;
    var file_url: String;
    var license: String;
    var capital: String;
    var latitude: Double;
    var longitude: Double;
    
    var index: Int?
//    var isFavorite: Bool = false
    
    func wikiUrl() -> URL? {
        URL(string: url)
    }
    
    func label() -> String {
        let sindex = index ?? 0
        return "\(sindex) \(alpha3) \(name)"
    }
    
}

let FlagItem_Sample = FlagItem(
    url: "/wiki/Jamaica",
    alpha3: "JAM", 
    name: "Jamaica", 
    file_url: "//upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg", 
    license: "Public domain",
    capital: "Kingston",
    latitude: 18,
    longitude: -76.48
)
