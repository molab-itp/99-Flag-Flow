//
//  ViewController.swift
//  SwiftGlobe
//
//  Created by David Mojdehi on 4/6/17.
//  Copyright © 2017 David Mojdehi. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit


class ViewController: UIViewController {

    @IBOutlet weak var sceneView : SCNView!
    
    var swiftGlobe = SwiftGlobe(alignment: .poles)
    var location: Location?
    
    override func viewDidLoad() {
        print("ViewController viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        swiftGlobe.setupInSceneView(sceneView, forARKit: false, enableAutomaticSpin: true)
        swiftGlobe.setupInSceneView(sceneView, forARKit: false, enableAutomaticSpin: false)
//        swiftGlobe.addDemoMarkers()
        updateLocation()
    }

    func setLocation(newLoc:Location) {
        location = newLoc;
        updateLocation();
    }
    
    func updateLocation() {
        if let location {
            print("updateLocation", location)
            swiftGlobe.focusOnLatLon( Float(location.latitude), Float(location.longitude))
        }
        else {
            swiftGlobe.focusOnLatLon( 0.0, 0.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewController viewDidAppear")
        updateLocation();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

