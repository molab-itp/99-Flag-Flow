//
//  FlagModel.swift
//  ViewFlags
//
//  Created by jht2 on 11/12/23.
//

import Foundation

//{
//    "url": "/wiki/Jamaica",
//    "alpha3": "JAM",
//    "name": "Jamaica",
//    "file_url": "//upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg",
//    "license": "Public domain"
//},

struct FlagItem : Decodable {
    var url: String;
    var alpha3: String;
    var name: String;
    var file_url: String;
    var license: String;
    var index: Int?
    
    func wikiUrlFor() -> URL? {
        URL(string: "https://en.wikipedia.org" + url)
    }
    
    func label() -> String {
        let sindex = index ?? 0
        return "\(sindex) \(alpha3) \(name)"
    }

}
