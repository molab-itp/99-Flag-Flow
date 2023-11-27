//
//  LocationModel-Nearby.swift
//  EarthFlags
//
//  Created by jht2 on 11/26/23.
//

import Foundation

extension LocationModel {
    
    func fetchNearbyPlaces() async {
        let loc = currentLocation;
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(loc.coordinate.latitude)%7C\(loc.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }

}
