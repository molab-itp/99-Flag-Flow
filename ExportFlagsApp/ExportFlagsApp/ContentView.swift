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
                    model.export( displayScale);
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
    
    @EnvironmentObject var model:Model
    
    @Environment(\.displayScale) var displayScale
        
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
            
            SVGViewSync(strRef: strRef)
            
            Text("rendered:")
            
            if let uiImage = model.uiImage {
                Image(uiImage: uiImage)
            }
//            if let renderedImage = model.renderedImage {
//                renderedImage
//            }
        }
        .padding()
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

#Preview {
    ContentView()
        .environmentObject(Model())
}
