//
//  asyncData.swift
//  CountryFlagsSVG
//
//  Created by jht2 on 11/12/23.
//

import Foundation

// Load and return the source of a url as Data
func dataFor(url: URL) -> Data! {
    // print("dataFor url", url)
    let startTime = Date.timeIntervalSinceReferenceDate
    guard let data = try? Data(contentsOf: url)else {
        print("dataFor data nil")
        return nil
    }
    // print("dataFor data.count", data.count)
    let duration = Date.timeIntervalSinceReferenceDate - startTime
    print("dataFor duration", duration, "url", url)
    return data;
}

// Load and return the source of a url as Data
func asyncDataFor(url: String) async -> Data! {
    print("asyncDataFor url", url)
    let startTime = Date.timeIntervalSinceReferenceDate
    
    guard let url = URL(string: url) else {
        print("asyncDataFor url nil")
        return nil;
    }
    guard let data = try? Data(contentsOf: url)else {
        print("asyncDataFor data nil")
        return nil
    }
    // print("asyncDataFor data.count", data.count)
    let duration = Date.timeIntervalSinceReferenceDate - startTime
    print("asyncDataFor duration", duration, "url", url)
    return data;
}

// https://swdevnotes.com/swift/2020/timing_swift_functions/
//    let startTime = Date()
//    let endTime = Date()
//    let timetaken = DateInterval(start: startTime, end: endTime)
//    let duration = timetaken.duration

// Based on:
// - [07-ImageEditDemoJSON](https://github.com/molab-itp/07-ImageEditDemoJSON)
//  - 07-ImageEditDemoJSON/ImageEditDemo/image.swift
