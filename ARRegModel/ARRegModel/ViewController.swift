//
//  ViewController.swift
//  ARRegModel
//
//  Created by Mac on 2019/1/15.
//  Copyright © 2019 JessicaFuMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        guard let models = ARReferenceObject.referenceObjects(inGroupNamed: "models", bundle: nil) else { return }
        
        configuration.detectionObjects = models
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        if let anchor = anchor as? ARObjectAnchor {
            print("Found 3D object: \(anchor.referenceObject.name!)")
        }
        let overlayNode = createOverlayNode(for: anchor as! ARObjectAnchor)
        return overlayNode
    }

    
    func createOverlayNode(for anchor: ARObjectAnchor) -> SCNNode {
        // 1
        let object = anchor.referenceObject
        
        // 2
        let box = SCNBox(
            width: CGFloat(object.extent.x),
            height: CGFloat(object.extent.y),
            length: CGFloat(object.extent.z),
            chamferRadius: 0
        )
        
        // 3
        let materials: [SCNMaterial] = [
            UIColor.red,
            UIColor.yellow,
            UIColor.orange,
            UIColor.white,
            UIColor.blue,
            UIColor.green
            ].map(createMaterial)
        
        // 4
        box.materials = materials
        
        // 5
        return SCNNode(geometry: box)
    }
    
    func createMaterial(with color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.transparency = 0.2
        
        return material
    }
  
}
