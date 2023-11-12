//
//  Exporter.swift
//  ExtractFlagsJSON
//
//  Created by jht2 on 11/12/23.
//

import Foundation

//        {
//            "url": "/wiki/Jamaica",
//            "alpha3": "JAM",
//            "name": "Jamaica",
//            "file_url": "//upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg",
//            "license": "Public domain"
//        },

// Write out svg
func export(alpha3: String, file_url: String, name: String, outDir: URL) {
    guard let durl = URL(string: "https:" + file_url) else {
        return;
    }
    guard let data = try? Data(contentsOf: durl) else {
        print("export no data")
        return;
    }
    print("export data length", data.count)
    let dirName = "flag-\(alpha3).imageset";
    guard let subDir = createDirectory(inDir: outDir, dirName: dirName) else {
        return;
    }
    let fileName = durl.lastPathComponent.asciiOnly();
    print("export fileName", fileName)
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

// contentsJSON.write(to:
// https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory

// https://chat.openai.com/c/5642c2ae-85b1-416f-8a9e-2a308486bb5d
// https://chat.openai.com/share/3d6c2f56-f0e8-4dc2-a216-57f323c3c3fc

extension String {
    func asciiOnly() -> String {
        let asciiCharacters = self.unicodeScalars.filter { $0.isASCII }
        return String(String.UnicodeScalarView(asciiCharacters))
    }
}

