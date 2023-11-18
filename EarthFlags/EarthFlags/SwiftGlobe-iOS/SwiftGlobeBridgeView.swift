//
//  SwiftGlobe_iOS_View.swift
//  EarthFlags
//
//  Created by jht2 on 11/18/23.
//

import SwiftUI

struct SwiftGlobeBridgeView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        print("BridgeView makeUIViewController")
        
//        let storyBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil);
//        let viewCtl = storyBoard.instantiateViewController(withIdentifier: "main") as! ViewController;
        let viewCtl = ViewController();
        
        print("BridgeView viewCtl", viewCtl)
        
        return viewCtl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("BridgeView updateUIViewController")
    }
}

#Preview {
    SwiftGlobeBridgeView()
}

// Blank screen
//    BridgeView makeUIViewController
//    BridgeView viewCtl <EarthFlags.ViewController: 0x100a05530>
//    ViewController viewDidLoad
//    SwiftGlobe setupInSceneView
//    SwiftGlobe addDemoMarkers
//    BridgeView updateUIViewController
//    ViewController viewDidAppear
