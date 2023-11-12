//
//  asyncData.swift
//  CountryFlagsSVG
//
//  Created by jht2 on 11/12/23.
//

import Foundation

func asyncDataFor(url: String) async -> Data! {
    print("asyncDataFor url", url)
    guard let url = URL(string: url) else {
        print("asyncDataFor url nil")
        return nil;
    }
    guard let data = try? Data(contentsOf: url)else {
        print("asyncDataFor data nil")
        return nil
    }
    print("asyncDataFor data.count", data.count)
    return data;
}
