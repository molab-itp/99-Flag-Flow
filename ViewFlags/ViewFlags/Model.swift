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
}


func getCountriesFromJSON() -> [FlagItem] {
    var flags = Bundle.main.decode([FlagItem].self, from: "countries.json")
    flags = flags.sorted { $0.alpha3 < $1.alpha3 }
    for index in 0..<flags.count {
        flags[index].index = index+1;
    }
    return flags
}
