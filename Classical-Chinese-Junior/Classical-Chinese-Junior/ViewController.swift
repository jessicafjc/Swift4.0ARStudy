//
//  ViewController.swift
//  Classical-Chinese-Junior
//
//  Created by Mac on 2018/12/25.
//  Copyright © 2018 JessicaFuMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var scene:SCNScene!
    var cameraNode: SCNNode!
    var textNodeArr = [SCNNode]()
    var spawnTime: TimeInterval = 0
    var nodeIndex = 0
    var textModel = TextModel()
    
    //    var titleText = "江雪"
    //    var authorText = "柳宗元"
    //    var contenttText = "江雪柳宗元千山鸟飞绝，万径人踪灭。孤舟蓑笠翁，独钓寒江雪。"
    //    var textString = titleText + authorText + contenttText
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupCamera()
        setTextNode(textArr: setText())
        setNodeAction()
        
    }
    func setText() -> [String]{
        textModel.titleText = "江雪"
        textModel.authorText = "柳宗元"
        textModel.contenttText = ["千山鸟飞绝，","万径人踪灭。","孤舟蓑笠翁，","独钓寒江雪。"]
        textModel.setTextString()
        return textModel.textString!
    }
    func setupScene() {
        sceneView.delegate = self
        scene = SCNScene()
        sceneView.scene = scene
        scene.rootNode.position = SCNVector3(0, 0, 0)
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        
    }
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
    }
    func setTextNode(textArr:[String]){
        let fontFamily = "Heiti TC"
        //FIX
        for i in 0..<textArr.count {
            var index = 0
            
            for c in textArr[i] {
                let text = SCNText(string: c.description, extrusionDepth: 0.3)
                let node = SCNNode(geometry: text)
                node.position = SCNVector3Make(Float(-2+index),Float(5-i*2), -10)
                node.name = c.description
                index += 1
                text.font = UIFont(name: fontFamily, size: 1)
                textNodeArr.append(node)
                //print("测试：\(text.font.familyName)")
                //scene.rootNode.addChildNode(node)
            }
        }
        
    }
    
    func setNodeAction(){
        // 1
        let duration = 0.2
        // 2
        let bounceUpAction = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration:duration)
        let bounceDownAction = SCNAction.moveBy(x: 0, y: -1.0, z: 0, duration:duration)
        let jumpAction =  SCNAction.sequence([bounceUpAction,bounceDownAction])
        let repeatAction = SCNAction.repeat(jumpAction, count: 1)
        for node in textNodeArr {
            node.runAction(repeatAction)
        }
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
        let touch  = touches.first! // 获取首次触摸
        let location = touch.location(in: sceneView) // 将触摸转换成scnView的坐标
        let hitResults = sceneView.hitTest(location, options: nil)
        if let result = hitResults.first {
            guard let name = result.node.name else { print("测试：nil)"); return }
            print("选择节点：\(name)")
            let action = SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 0.5)
            let repeatAction = SCNAction.repeat(action, count: 1)
            result.node.runAction(repeatAction)
        }
    }
}
extension ViewController: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time:
        TimeInterval) {
        
        if time > spawnTime {
            guard nodeIndex < textNodeArr.count else { return }
            scene.rootNode.addChildNode(textNodeArr[nodeIndex])
            nodeIndex += 1
            spawnTime = time + TimeInterval(0.5)
        }
        
    }
    
}
