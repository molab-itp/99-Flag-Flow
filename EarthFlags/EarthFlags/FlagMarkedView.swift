//
//  FlagFavsView.swift
//  ViewFlags
//
//  Created by jht2 on 11/17/23.
//

import SwiftUI

struct FlagMarkedView: View {
    
    @State var marked: [FlagItem] = []
    
    @EnvironmentObject var model: AppModel

    var body: some View {
        ZStack {
            Rectangle()
                .background(Color(white: 0.9))
                .foregroundStyle(Color(white: 0.8))
            VStack {
                // Query count from model to get modified count
                Text("\(model.marked().count) Marked")
                    .padding()
                List {
                    ForEach(marked, id: \.alpha3) { fitem in
                        FlagItemRowView(flagItem: fitem)
                    }
                }
            }
        }
        .onAppear {
            print("FlagMarkedView onAppear");
            // Capture marked here to so list not updated on marked status changed
            marked = model.marked();
        }
        .onDisappear {
            print("FlagMarkedView onDisappear")
        }
    }
    
}


#Preview {
    FlagMarkedView(marked: AppModel.sample.marked())
        .environmentObject(AppModel.sample)
}
