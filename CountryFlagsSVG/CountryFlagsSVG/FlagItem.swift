//
//  FlagModel.swift
//  ViewFlags
//
//  Created by jht2 on 11/12/23.
//

import Foundation

struct FlagItem : Decodable {
    var url: String;
    var alpha3: String;
    var name: String;
    var file_url: String;
    var license: String;
    var index: Int?
}
