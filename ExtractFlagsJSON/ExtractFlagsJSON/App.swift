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
    var fileIn: String = "/Users/jht2/Downloads/countries.json"
    
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
        process_output(process_in(json: json));
    }
    func process_in(json: Any) -> Any {
        guard let arr = json as? NSArray else {
            print("!! json not NSArray", json)
            return json;
        }
        print("arr.count", arr.count)
        // arr.count 238
        // print("arr", arr)
        for (index, elm) in arr.enumerated() {
            if let elm = elm as? NSDictionary {
                // print("index", index, "elm", elm)
                guard let file_url = elm["file_url"] as? String else {
                    print("!!@ index", index, "missing file_url")
                    continue;
                }
                print("index", index, "file_url", file_url)
            }
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

