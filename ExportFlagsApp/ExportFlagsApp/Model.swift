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
    
    @Published var uiImage:UIImage?

    var outDir = createDirectory(dirName: "export_jpeg")
    var displayScale: CGFloat = 1.0;
    
    var index = 0
    var countries = getCountriesFromJSON()
    var jpegQuality = 0.5;
    
    func next() {
        index = (index + 1) % countries.count;
        strRef = "https:" + countries[index].file_url;
    }
    
    @MainActor func exportAll() {
        for findex in 0..<countries.count {
            export1(findex);
        }
    }
    @MainActor func export() {
        export1(index);
    }
    
    @MainActor func export1(_ index:Int) {
        guard let outDir else {
            print("export no outDir")
            return;
        }
        let strRef = "https:" + countries[index].file_url;
        print("export1 index", index, strRef)
        let content = SVGViewSync(strRef: strRef)
        let renderer = ImageRenderer(content: content)
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
        uiImage = renderer.uiImage
        if let uiImage {
            print("Model export uiImage", uiImage)
            let fitem = countries[index]
//            let name = fitem.alpha3
//            export_jpeg(uiImage: uiImage, quality: 0.5, name: name, outDir: outDir)
            export_imageset(uiImage: uiImage, quality: jpegQuality, outDir:outDir,
                            alpha3: fitem.alpha3,
                            file_url: fitem.file_url,
                            name: fitem.name )
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
