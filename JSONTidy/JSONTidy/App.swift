//
//  main.swift
//  JSONTidy
//
//  Created by Paul Hudson on 10/07/2022.
//
// - https://www.hackingwithswift.com/plus/command-line-apps/json-tidy

import ArgumentParser
import Foundation

@main
struct App: ParsableCommand {
    @Option(name: .shortAndLong, help: "Writes the output to a file rather than to standard output.")
    var output: String?

    @Flag(name: .shortAndLong, help: "Force overwrite files if they exist already.")
    var forceOverwrite = false

    @Flag(name: .shortAndLong, help: "Neatly formats the output.")
    var prettify = false

    @Flag(name: .shortAndLong, help: "Sort keys alphabetically.")
    var sort = false

    @Argument(help: "The filename you want to process.")
//    var file: String
    var file: String = "/Users/jht2/Downloads/sample.json"

    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "jsontidy", abstract: "Adjusts JSON files to compress or expand data, and also provide key sorting.")
    }

    func run() {
        let url = URL(fileURLWithPath: file)
        print("file", file);
        print("url", url);

        guard let contents = try? Data(contentsOf: url) else {
            print("Failed to read input file \(file)")
            return
        }

        guard let json = try? JSONSerialization.jsonObject(with: contents, options: .fragmentsAllowed) else {
            print("Failed to parse JSON in input file \(file)")
            return
        }
        
        // show author entry of sample.json
        print("json", json);
        if let dict = json as? NSDictionary {
            print("dict", dict)
            if let info = dict["info"] as? NSDictionary {
                print("info", info);
                if let author = info["author"] as? String {
                    print("author", author)
                }
            }
        }

        var writingOptions: JSONSerialization.WritingOptions = []

//        if prettify {
            writingOptions.insert(.prettyPrinted)
//        }

//        if sort {
            writingOptions.insert(.sortedKeys)
//        }

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
                print("outputString:", outputString)
            }
        } catch {
            print("Failed to create JSON output.")
        }
    }
}

