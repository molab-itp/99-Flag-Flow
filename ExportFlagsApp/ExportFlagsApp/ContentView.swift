//
//  ContentView.swift
//  ExportFlagsApp
//
//  Created by jht2 on 11/15/23.
//

import SwiftUI
import SVGView

//let strRef = "https://upload.wikimedia.org/wikipedia/commons/0/0a/Flag_of_Jamaica.svg";
//let strRef1 = "https://upload.wikimedia.org/wikipedia/commons/9/99/Flag_of_Guyana.svg"
//let strRef2 = "https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg"

struct ContentView: View {
    
    @EnvironmentObject var model:Model
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        VStack {
            ExportingView(strRef: model.strRef)
            HStack {
                Button("Next") {
                    model.next();
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color(.systemIndigo))
                .cornerRadius(12)
                .padding(5)
                Button("Export") {
                    model.render( displayScale);
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color(.systemIndigo))
                .cornerRadius(12)
                .padding(5)
                
            }
        }
    }
}

struct ExportingView: View {
    var strRef: String;
    
    //    @State var renderedImage = Image(systemName: "photo")
    @EnvironmentObject var model:Model
    
    @Environment(\.displayScale) var displayScale
    
    //    let svgView = SVGViewSync(strRef: strRef);
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
            
            SVGViewSync(strRef: strRef)
            
            Text("rendered:")
            
            if let renderedImage = model.renderedImage {
                renderedImage
            }
            
            //            Button(action: {
            //                exportAction()
            //            }) {
            //                Text("Export")
            //                    .foregroundColor(.white)
            //                    .padding(10)
            //                    .background(Color(.systemIndigo))
            //                    .cornerRadius(12)
            //                    .padding(5)
            //            }
        }
        .padding()
    }
    
    //    @MainActor func exportAction() {
    //        //
    //        render();
    //    }
    //    
    //    @MainActor func render() {
    //        // let text = ["ONE", "TWO", "THREE", "MILLIONS"].randomElement();
    //        // let renderer = ImageRenderer(content: RenderView(text: text!))
    //        // let renderer = ImageRenderer(content: SVGViewAsync(strRef: strRef))
    //// let renderer = ImageRenderer(content: svgView)
    //        let content = SVGViewSync(strRef: strRef)
    //        let renderer = ImageRenderer(content: content)
    //
    //        // make sure and use the correct display scale for this device
    //        renderer.scale = displayScale
    //        
    //        if let uiImage = renderer.uiImage {
    ////            renderedImage = Image(uiImage: uiImage)
    //        }
    //        else {
    //            print("render no uiImage")
    //        }
    //    }
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

struct SVGViewSync: View {
    var strRef: String
    var width: CGFloat = 300
    var height: CGFloat = 200
    var label: String = ""
    var body: some View {
        VStack {
            SVGView(contentsOf: URL(string: strRef)!)
                .frame(width: width, height: height)
        }
    }
}

/// Asyncronously load svg in a View
struct SVGViewAsync: View {
    var strRef: String
    var width: CGFloat = 300
    var height: CGFloat = 200
    var label: String = ""
    @State var data: Data?
    var body: some View {
        VStack {
            if let data {
                SVGView(data: data)
                    .frame(width: width, height: height)
            }
        }
        .task {
            data = await asyncDataFor(url: strRef)
            // print("task data after", data ?? "-none-")
            print("SVGViewAsync strRef", label, strRef)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Model())
}
