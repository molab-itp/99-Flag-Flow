//
//  Exporter.swift
//  ExportFlagsApp
//
//  Created by jht2 on 11/15/23.
//

import Foundation
import UIKit

//        {
//            "url": "/wiki/Jamaica",
//            "alpha3": "JAM",
//            "name": "Jamaica",
//            "file_url": "//upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg",
//            "license": "Public domain"
//        },

// write svg to directory outDir
//  eg flag-JAM.imageset
//      Contents.json
//      fileName -- eg Flag_of_Jamaica.svg

//func export_jpeg(uiImage: UIImage, quality: CGFloat, name: String, outDir: URL) {
//    print("export_jpeg name", name)
//    guard let data = uiImage.jpegData(compressionQuality: quality) else {
//        print("export_jpeg no data name", name)
//        return;
//    }

// Write out svg
func export_imageset(uiImage: UIImage, quality: CGFloat, outDir: URL, alpha3: String, file_url: String, name: String) {
    print("export_imageset name", name)
    guard let data = uiImage.jpegData(compressionQuality: quality) else {
        print("export_imageset no data name", name)
        return;
    }
    print("export_imageset data length", data.count)
    let dirName = "flag-\(alpha3).imageset";
    guard let subDir = createDirectory(inDir: outDir, dirName: dirName) else {
        print("export_imageset failed createDirectory")
        return;
    }
    guard let furl = URL(string: "https:" + file_url) else {
        print("export_imageset failed durl")
        return;
    }
    let jpgURL = furl
        .deletingPathExtension()
        .appendingPathExtension("jpg")
    let fileName = jpgURL.lastPathComponent.asciiOnly();
    print("export_imageset fileName", fileName)
    let outFile = subDir.appendingPathComponent(fileName);
    do {
        try data.write(to: outFile)
    }
    catch {
        print("export data write error", error)
    }
    let contentsJSON = """
        {
          "images" : [
            {
              "filename" : "\(fileName)",
              "idiom" : "universal",
              "scale" : "1x"
            },
            {
              "idiom" : "universal",
              "scale" : "2x"
            },
            {
              "idiom" : "universal",
              "scale" : "3x"
            }
          ],
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """;
    let cjsonOutFile = subDir.appendingPathComponent("Contents.json");
    do {
        try contentsJSON.write(to: cjsonOutFile, atomically: true, encoding: .utf8)
    }
    catch {
        print("contentsJSON.write error", error)
    }
    
}

func export_jpeg(uiImage: UIImage, quality: CGFloat, name: String, outDir: URL) {
    print("export_jpeg name", name)
    guard let data = uiImage.jpegData(compressionQuality: quality) else {
        print("export_jpeg no data name", name)
        return;
    }
    print("export_jpeg data length", data.count)
    let fileName = name + ".jpg"
    let outFile = outDir.appendingPathComponent(fileName);
    print("export_jpeg outFile", outFile)
    do {
        try data.write(to: outFile)
    }
    catch {
        print("export data write error", error)
    }
}

// https://chat.openai.com/c/5642c2ae-85b1-416f-8a9e-2a308486bb5d
// https://chat.openai.com/share/3d6c2f56-f0e8-4dc2-a216-57f323c3c3fc

extension String {
    func asciiOnly() -> String {
        let asciiCharacters = self.unicodeScalars.filter { $0.isASCII }
        return String(String.UnicodeScalarView(asciiCharacters))
    }
}
