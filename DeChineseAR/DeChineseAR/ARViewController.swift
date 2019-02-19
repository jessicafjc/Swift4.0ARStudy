//
//  ARViewController.swift
//  DeChineseAR
//
//  Created by Mac on 2019/2/18.
//  Copyright © 2019 JiachenFu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var foundSurface = false
    var started = false
    var tapTarget = ""
    var planeNdoe: SCNNode!
    var containerPosition = SCNVector3Make(0.0, 0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tapTarget)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if started {
            print("已开启书籍")
        } else {
            planeNdoe.removeFromParentNode()
            started = true
            guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
            container.isHidden = false
            container.position = containerPosition
            sceneView.scene.rootNode.addChildNode(container)
//            guard let characterNode = container.childNode(withName: "characterNode", recursively: false) else { return }
//            let text = SCNText(string: tapTarget, extrusionDepth: 2)
//            let textNode =  SCNNode(geometry: text)
//            text.font = UIFont.systemFont(ofSize: 0.01)
//            characterNode.addChildNode(textNode)
        }
        
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !started else { return }
        guard let hitTest = sceneView.hitTest(CGPoint(x: view.frame.midX, y:view.frame.midY), types: [.existingPlane,.featurePoint,.estimatedVerticalPlane]).first else { return }
        let trans = SCNMatrix4(hitTest.worldTransform)
        containerPosition = SCNVector3Make(trans.m41, trans.m42, trans.m43)
        if !foundSurface {
            let foundsurfacePlane = SCNPlane(width: 0.2, height: 0.2)
            // trackerPlane.firstMaterial?.diffuse.contents = trackerPlane.firstMaterial?.isDoubleSided = true
            foundsurfacePlane.firstMaterial?.diffuse.contents = UIImage(named:"Image" )
            planeNdoe = SCNNode(geometry: foundsurfacePlane)
            planeNdoe.eulerAngles.x = -.pi * 0.5
            sceneView.scene.rootNode.addChildNode(planeNdoe)
            
            foundSurface = true
            
        }
        
      planeNdoe.position = containerPosition
    }
    
}
