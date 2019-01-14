//
//  ViewController.swift
//  DiceAR
//
//  Created by Mac on 2019/1/14.
//  Copyright © 2019 JessicaFuMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var trackerNdoe: SCNNode!
    var diceNode: SCNNode!
    var dice2Node: SCNNode!
    var trackingPosition = SCNVector3Make(0.0, 0.0, 0.0)
    var started = false
    var foundSurface = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func rollDice(dice: SCNNode){
        if dice.physicsBody == nil {
            dice.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        }
        dice.physicsBody?.applyForce(SCNVector3Make(0.0, 3.0, 0.0), asImpulse: true)
        dice.physicsBody?.applyTorque(SCNVector4Make(1.0, 1.0, 1.0, 0.1), asImpulse: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if started {
          rollDice(dice: diceNode)
          rollDice(dice: dice2Node)

        } else {
            trackerNdoe.removeFromParentNode()
            started = true
            
            let floorPlane = SCNPlane(width: 50.0, height: 50.0)
            floorPlane.firstMaterial?.diffuse.contents = UIColor.clear
            
            let floorNode = SCNNode(geometry: floorPlane)
            floorNode.position = trackingPosition
            floorNode.eulerAngles.x = -.pi * 0.5
            sceneView.scene.rootNode.addChildNode(floorNode)
            floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            
            guard let dice = sceneView.scene.rootNode.childNode(withName: "dice", recursively: false) else { return }
            diceNode = dice
            diceNode.position = SCNVector3Make(trackingPosition.x, trackingPosition.y + 0.05, trackingPosition.z)
            diceNode.isHidden = false
            dice2Node = diceNode.clone()
            dice2Node.position.x = trackingPosition.x + 0.15
            sceneView.scene.rootNode.addChildNode(dice2Node)
        }
    }
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !started else { return }
        guard let hitTest = sceneView.hitTest(CGPoint(x: view.frame.midX, y:view.frame.midY), types: [.existingPlane,.featurePoint,.estimatedVerticalPlane]).first else { return }
        let trans = SCNMatrix4(hitTest.worldTransform)
        trackingPosition = SCNVector3Make(trans.m41, trans.m42, trans.m43)
        
        if !foundSurface {
            let trackerPlane = SCNPlane(width: 0.2, height: 0.2)
           // trackerPlane.firstMaterial?.diffuse.contents = trackerPlane.firstMaterial?.isDoubleSided = true
            trackerPlane.firstMaterial?.diffuse.contents = UIImage(named:"PlaneImage" )
            trackerNdoe = SCNNode(geometry: trackerPlane)
            trackerNdoe.eulerAngles.x = -.pi * 0.5
            sceneView.scene.rootNode.addChildNode(trackerNdoe)
            
            foundSurface = true
            
        }
        trackerNdoe.position = trackingPosition
    }
}
