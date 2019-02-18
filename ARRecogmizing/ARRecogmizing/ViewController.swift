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
    //设立一个根节点
    var rootNode: SCNNode!
    //设立内容节点
    var containerNode: SCNNode!
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
        
        rootNode = scene.rootNode
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
    }
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        rootNode.addChildNode(cameraNode)
    }
    // FIX: ASD
    // MARK: - ARSCNViewDelegate (Image detection results)
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let referenceImage = imageAnchor.referenceImage
        if (referenceImage.name != nil) {
         
            containerNode = setRecogmizedNode(referenceImageName: referenceImage.name!)
           
            node.addChildNode(containerNode!)

        }
        
    }
    //此函数为全模型加载
    
    func setRecogmizedNode(referenceImageName:String) -> SCNNode? {
        print("referenceImage.name : \(String(describing: referenceImageName))")
        guard let container = scene.rootNode.childNode(withName: "bamboo", recursively: false) else { return nil }
        container.removeFromParentNode()
        container.isHidden = false
        
        //竹子树节点
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
        
        return container
    }
    func setChineseNode(){
        guard let container = scene.rootNode.childNode(withName: "bamboo", recursively: false) else { return  }
        guard let chineseNode = container.childNode(withName: "chineseNode", recursively: false) else { return  }
        var fontFamily = ["JGW","eY'","yuweij","STLiti","STKaiti","FZXZTFW--GB1-0","FZKCTest"]
        for i in 0...6{
            let chineseText = SCNText(string: "竹", extrusionDepth: 0.3)
            let node = SCNNode(geometry: chineseText)
            node.position = SCNVector3Make(Float(i), 0, 0)
            chineseText.font = UIFont(name: fontFamily[i], size: 1)
            chineseNode.scale = SCNVector3(0.1, 0.1, 0.1)
            chineseNode.addChildNode(node)
        }

        
    }
    func setParticle(particleName:String,addNode:SCNNode){
        let particle = SCNParticleSystem(named: "\(particleName).scnp", inDirectory: nil)!
        addNode.addParticleSystem(particle)
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch  = touches.first! // 获取首次触摸
        let location = touch.location(in: sceneView) // 将触摸转换成scnView的坐标
        let hitResults = sceneView.hitTest(location, options: nil)
        if let result = hitResults.first {
            guard let name = result.node.name else { print("测试：nil)"); return }
            print("选择节点：\(name)")
            switch name {
            case "bamboo_tree":
                guard let bamboo_xx = containerNode.childNode(withName: "bamboo_xx", recursively: false) else { return  }
                bamboo_xx.isHidden = false
                let moveAction = SCNAction.move(to: SCNVector3(0.473 , 0.613, -0.005), duration: 0.5)
                let eulerAction = SCNAction.rotateTo(x: 0, y: -90, z: 0, duration: 0.5)
                let action = SCNAction.group([moveAction,moveAction])
                bamboo_xx.runAction(action)
                
            case "bamboo_xx":
                setChineseNode()
            default:
                print("选择错误")
            }
            
            result.node.isHidden = false
            let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 0.5)
            let repeatAction = SCNAction.repeat(action, count: 1)
            result.node.runAction(repeatAction)
            
        }
        func cleanScene() {
            for node in scene.rootNode.childNodes {
                
                node.removeFromParentNode()
                
            }
        }
    }
}


