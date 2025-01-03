//
//  App.swift

// Swift command line tool to convert svg country flags to Assets.xcassets format

import ArgumentParser
import Foundation

@main
struct App: ParsableCommand {
    @Option(name: .shortAndLong, help: "Writes the output to a file rather than to standard output.")
    var output: String?

    @Argument(help: "The filename you want to process.")
//    var fileIn: String = "/Users/jht2/Downloads/countries-STP-VAT.json"
//    var outDirName = "exported_svgs-imageset";
    var fileIn: String = "/Users/jht2/Downloads/countries-2.json"
    var outDirName = "exported-svgs";

    // Not used yet
    var forceOverwrite = false
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "extractFlagsJSON",
            abstract: "convert svg country flags to Assets.xcassets format")
    }
    
    
    func run() {
        let url = URL(fileURLWithPath: fileIn)
        print("file", fileIn);
        print("url", url);
        guard let contents = try? Data(contentsOf: url) else {
            print("Failed to read input fileIn \(fileIn)")
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: contents, options: .fragmentsAllowed) else {
            print("Failed to parse JSON in input file \(fileIn)")
            return
        }
        guard let outDir = createDirectory(dirName:outDirName) else {
            print("Failed to createDirectory file \(outDirName)")
            return;
        }
        process_output(process_in(json: json, outDir: outDir));
    }
    func process_in(json: Any, outDir: URL) -> Any {
        guard let arr = json as? NSArray else {
            print("!! json not NSArray", json)
            return json;
        }
        print("arr.count", arr.count)
        // arr.count 238
        // print("arr", arr)
        
//        {
//            "url": "/wiki/Jamaica",
//            "alpha3": "JAM",
//            "name": "Jamaica",
//            "file_url": "//upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg",
//            "license": "Public domain"
//        },

        for (index, elm) in arr.enumerated() {
            guard let elm = elm as? NSDictionary else {
                print("!!@ index", index, "missing elm")
                continue;
            }
            // print("index", index, "elm", elm)
            // alpha3
            guard let alpha3 = elm["alpha3"] as? String else {
                print("!!@ index", index, "missing alpha3")
                continue;
            }
            print("index", index, "alpha3", alpha3)
            // name
            guard let name = elm["name"] as? String else {
                print("!!@ index", index, "missing name")
                continue;
            }
            print("index", index, "name", name)
            // file_url
            guard let file_url = elm["file_url"] as? String else {
                print("!!@ index", index, "missing file_url")
                continue;
            }
            print("index", index, "file_url", file_url)
            // export_imageset(alpha3: alpha3, file_url: file_url, name: name, outDir: outDir)
            export_svgs(alpha3: alpha3, file_url: file_url, name: name, outDir: outDir)
//            if index == 1 {
//                break
//            }
        }
        // if let info = dict["info"] as? NSDictionary {
        // print("info", info);
        // if let author = info["author"] as? String {
        //  print("author", author)
        return json
    }
    func process_output(_ json:Any) {
        var writingOptions: JSONSerialization.WritingOptions = []
        writingOptions.insert(.prettyPrinted)
        // writingOptions.insert(.sortedKeys)
        do {
            let newData = try JSONSerialization.data(withJSONObject: json, options: writingOptions)
            if let output = output {
                let outputURL = URL(fileURLWithPath: output)
                if FileManager.default.fileExists(atPath: outputURL.path) && forceOverwrite == false {
                    print("Aborting: \(output) exists already.")
                } else {
                    try newData.write(to: outputURL)
                }
            } else {
                let outputString = String(decoding: newData, as: UTF8.self)
                // print(outputString)
                print("outputString.count", outputString.count)
            }
        } catch {
            print("Failed to create JSON output.")
        }
    }
}


// Based on
//  JSONTidy
//  Created by Paul Hudson on 10/07/2022.
// - https://www.hackingwithswift.com/plus/command-line-apps/json-tidy

