//
//  FlagFavsView.swift
//  ViewFlags
//
//  Created by jht2 on 11/17/23.
//

import SwiftUI

struct FlagFavsView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            VStack {
                List {
                    ForEach(findFavs, id: \.alpha3) { fitem in
                        FlagItemRowView(flagItem: fitem)
                    }
                }
            }
        }
    }
    
    var findFavs: [FlagItem] {
        model.flagItems.filter {
            model.isFavorite(flagItem: $0)
        }
    }
}


#Preview {
    FlagFavsView()
        .environmentObject(Model.example)
}
