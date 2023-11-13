//
//  asyncData.swift
//  CountryFlagsSVG
//
//  Created by jht2 on 11/12/23.
//

import Foundation

// Load and return the source of a url as Data
func asyncDataFor(url: String) async -> Data! {
//    print("asyncDataFor url", url)
    guard let url = URL(string: url) else {
        print("asyncDataFor url nil")
        return nil;
    }
    guard let data = try? Data(contentsOf: url)else {
        print("asyncDataFor data nil")
        return nil
    }
//    print("asyncDataFor data.count", data.count)
    return data;
}

// Based on:
// - [07-ImageEditDemoJSON](https://github.com/molab-itp/07-ImageEditDemoJSON)
//  - 07-ImageEditDemoJSON/ImageEditDemo/image.swift
