//
//  ContentView.swift
//  ExportFlagsApp
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var renderedImage = Image(systemName: "photo")

    @Environment(\.displayScale) var displayScale

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
            
            renderedImage

            Button(action: {
                exportAction()
                }) {
                Text("Export")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(.systemIndigo))
                    .cornerRadius(12)
                    .padding(5)
            }
        }
        .padding()
    }
    
    @MainActor func exportAction() {
        //
        render();
    }
    
    @MainActor func render() {
        let text = ["ONE", "TWO", "THREE", "MILLIONS"].randomElement();
        let renderer = ImageRenderer(content: RenderView(text: text!))
        
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    ContentView()
}

// An example view to render
struct RenderView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(Capsule())
    }
}
