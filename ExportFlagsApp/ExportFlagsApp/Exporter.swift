//
//  Exporter.swift
//  ExportFlagsApp
//
//  Created by jht2 on 11/15/23.
//

import Foundation
import UIKit

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
