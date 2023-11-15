//
//  Model.swift
//  ExportFlagsApp
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI
import SVGView

class Model : ObservableObject {
    
    @Published var strRef = "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg"
    
    @Published var renderedImage:Image?
    
    var index = 0
    var countries = getCountriesFromJSON()

    func next() {
        index = (index + 1) % countries.count;
        strRef = "https:" + countries[index].file_url;
    }
    
    @MainActor func render(_ displayScale: CGFloat) {
        // let text = ["ONE", "TWO", "THREE", "MILLIONS"].randomElement();
        // let renderer = ImageRenderer(content: RenderView(text: text!))
        // let renderer = ImageRenderer(content: SVGViewAsync(strRef: strRef))
        // let renderer = ImageRenderer(content: svgView)
        let content = SVGViewSync(strRef: strRef)
        let renderer = ImageRenderer(content: content)
        
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
            print("Model render uiImage", uiImage)
        }
        else {
            print("render no uiImage")
        }
    }

}

func getCountriesFromJSON() -> [FlagItem] {
    var flags = Bundle.main.decode([FlagItem].self, from: "countries.json")
    //    flags = flags.shuffled();
    for index in 0..<flags.count {
        flags[index].index = index;
    }
    return flags
}

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
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        return loaded
    }
}
