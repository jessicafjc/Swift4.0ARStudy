//
//  ViewController.swift
//  ARRecogmizing
//
//  Created by Mac on 2018/12/28.
//  Copyright © 2018 JessicaFuMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit
class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    //设立一个空场景
    var scene: SCNScene!
    //设立一个cameraNode节点作为相机节点
    var cameraNode: SCNNode!
    
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        //setupCamera()
        //createNode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Images", bundle: nil) else {
            return
        }
        configuration.trackingImages = arImages
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - Session management (Image detection setup)
    
    func setupScene() {
        // Set the view's delegate
        sceneView.delegate = self
        // Create a new scene
        //scene = SCNScene()
        scene = SCNScene(named: "art.scnassets/bamboo.scn")
        // Set the scene to the view
        sceneView.scene = scene
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
    }
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
    }
    // FIX: ASD
    // MARK: - ARSCNViewDelegate (Image detection results)
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let referenceImage = imageAnchor.referenceImage
        if (referenceImage.name != nil) {
            //let imageWidth = referenceImage.physicalSize.width
            // let imageHeight = referenceImage.physicalSize.height
            //var setNode = setRecogmizedNode(referenceImageName: referenceImage.name!)
           
            //Animations
            setChineseNode()
            let containerNode = setRecogmizedNode(referenceImageName: referenceImage.name!)
           
            //chineseNode.geometry = chineseName
            //chineseNode = SCNNode(geometry: chineseName)
            //chineseNode.scale = SCNVector3(0.1, 0.1, 0.1)
            
            node.addChildNode(containerNode!)
            //粒子系统
            
            
        }
        
    }
    //此函数为全模型加载
    
    func setRecogmizedNode(referenceImageName:String) -> SCNNode? {
        print("referenceImage.name : \(String(describing: referenceImageName))")
        guard let container = scene.rootNode.childNode(withName: "bamboo", recursively: false) else { return nil }
        container.removeFromParentNode()
        container.isHidden = false
        
        guard let bamboo_tree = container.childNode(withName: "bamboo_tree", recursively: false) else { return nil }
        bamboo_tree.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),SCNAction.scale(to:0.002,duration:1.5)]))
        guard let bambooArr = container.childNode(withName: "bambooArr", recursively: false) else { return nil }
        for node in bambooArr.childNodes {
            let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
            let repeatAction = SCNAction.repeatForever(action)
            node.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),repeatAction]))
        }
        guard let particleNode = container.childNode(withName: "particle", recursively: false) else { return nil }
        container.addChildNode(particleNode)
        setParticle(particleName: "leafrain", addNode: particleNode)
        
        //particleNode.addParticleSystem(particle)
        return container
    }
    func setChineseNode(){
        guard let container = scene.rootNode.childNode(withName: "bamboo", recursively: false) else { return  }
        guard let chineseNode = container.childNode(withName: "chineseNode", recursively: false) else { return  }
        var fontFamily = ["HYChenTiJiaGuWen","eY'","yuweij","STLiti","STKaiti","FZXZTFW--GB1-0","yuweij","FZKCTest"]
        for i in 0...6{
            let chineseText = SCNText(string: "竹", extrusionDepth: 0.3)
            
            let node = SCNNode(geometry: chineseText)
            node.position = SCNVector3Make(Float(i), 0, 0)
            chineseText.font = UIFont(name: fontFamily[i], size: 1)
            chineseNode.scale = SCNVector3(0.1, 0.1, 0.1)
            chineseNode.addChildNode(node)
        }
//        return chineseNode
        //            let duration = 0.2
        //            // 2
        //            let bounceUpAction = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration:duration)
        //            let bounceDownAction = SCNAction.moveBy(x: 0, y: -1.0, z: 0, duration:duration)
        //            let jumpAction =  SCNAction.sequence([bounceUpAction,bounceDownAction])
        //            let repeatAction = SCNAction.repeatForever(jumpAction)
        //            xiNode.runAction(repeatAction)
        //            container.addChildNode(xiNode)
        
    }
    func setParticle(particleName:String,addNode:SCNNode){
        let particle = SCNParticleSystem(named: "\(particleName).scnp", inDirectory: nil)!
        addNode.addParticleSystem(particle)
    }
    func cleanScene() {
        for node in scene.rootNode.childNodes {
            
            node.removeFromParentNode()
            
        }
    }
    
    
}


