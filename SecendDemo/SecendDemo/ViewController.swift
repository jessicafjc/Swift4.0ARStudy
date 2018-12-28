//
//  ViewController.swift
//  SecendDemo
//
//  Created by Mac on 2018/12/11.
//  Copyright © 2018 JessicaFuMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    //设立一个空场景
    var scene: SCNScene!
    //设立一个cameraNode节点作为相机节点
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupCamera()
        createNode()
        
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
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    func setupScene() {
        // Set the view's delegate
        sceneView.delegate = self
        // Create a new scene
        scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
    }
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        // 4
        scene.rootNode.addChildNode(cameraNode)
    }
    func createNode(){
        let role = "lan"
        guard let portalScene = SCNScene(named: "art.scnassets/\(role).scn") else {return}
        let roleNode = portalScene.rootNode.childNode(withName: "lan", recursively: true)
        roleNode!.position = SCNVector3(0,0,-5)
        roleNode!.name = role
        scene.rootNode.addChildNode(roleNode!)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
