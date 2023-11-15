//
//  RenderImage.swift
//  ExportFlagsApp
//
//  Created by jht2 on 11/15/23.
//

//
// From SwiftUI by Example by Paul Hudson
// https://www.hackingwithswift.com/quick-start/swiftui
//
// You're welcome to use this code for any purpose,
// commercial or otherwise, with or without attribution.
//

import SwiftUI


struct ContentView_Render: View {
    @State private var text = "Your text here"
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        VStack {
            renderedImage
            
            ShareLink("Export", item: renderedImage, preview: SharePreview(Text("Shared image"), image: renderedImage))
            
            TextField("Enter some text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .onChange(of: text) { _ in render() }
        .onAppear { render() }
    }
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: RenderView(text: text))
        
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
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
