//
//  ViewController.swift
//  ChineseCharactersAR
//
//  Created by Mac on 2018/12/22.
//  Copyright © 2018 JessicaFuMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var scene:SCNScene!
    var cameraNode: SCNNode!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        
        setupCamera()
        
       // createNode()
        
ARLantingxu()
        //ARtest()
    }
    
    
    func setupScene() {
        
        // Set the view's delegate
        
        sceneView.delegate = self
        
        // Create a new scene
        
        scene = SCNScene()
        
        // Set the scene to the view
        
        sceneView.scene = scene
        scene.rootNode.position = SCNVector3(0, 0, 0)
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
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        // 4
        
        scene.rootNode.addChildNode(cameraNode)
        
    }
    
//    func createNode(){
//
//        let role = "lan"
//
//        guard let portalScene = SCNScene(named: "art.scnassets/(role).scn") else {return}
//
//        let roleNode = portalScene.rootNode.childNode(withName: "lan", recursively: true)
//
//        roleNode!.position = SCNVector3(0,0,-10)
//
//        roleNode!.name = role
//
//        scene.rootNode.addChildNode(roleNode!)
//
//    }
    
    //HYa9gj
    func ARtest(){
        var nodeArr = [SCNNode]()
        var fontFamily = ["JXK","Heiti SC","Heiti TC","REEJI-Cappuccino-RegularGB1.0","HYa9gj"]
        for i in 0...4{
            let text = SCNText(string: "圣诞快乐", extrusionDepth: 0.3)
             let node = SCNNode(geometry: text)
            node.position = SCNVector3Make(0, Float(-5+2*i), -10)
            text.font = UIFont(name: fontFamily[i], size: 1)
            nodeArr.append(node)
            print("测试：\(text.font.familyName)")
            scene.rootNode.addChildNode(node)
        }
    }
        func ARLantingxu(){
            var textNodeArr = [SCNNode]()

            var title = "兰亭序"
            var textBody01 = "永和九年，岁在癸丑，暮春之初，会于会稽山阴之兰亭，修禊事也。群贤毕至，少长咸集。此地有崇山峻岭，茂林修竹，又有清流激湍，映带左右，引以为流觞曲水，列坐其次。虽无丝竹管弦之盛，一觞一咏，亦足以畅叙幽情。是日也，天朗气清，惠风和畅。仰观宇宙之大，俯察品类之盛，所以游目骋怀，足以极视听之娱，信可乐也。"
            var textBody02 = "夫人之相与，俯仰一世。或取诸怀抱，悟言一室之内；或因寄所托，放浪形骸之外。虽趣舍万殊，静躁不同，当其欣于所遇，暂得于己，快然自足，不知老之将至；及其所之既倦，情随事迁，感慨系之矣。向之所欣，俯仰之间，已为陈迹，犹不能不以之兴怀，况修短随化，终期于尽！古人云：“死生亦大矣。”岂不痛哉！"
            var textBody03 = "每览昔人兴感之由，若合一契，未尝不临文嗟悼，不能喻之于怀。固知一死生为虚诞，齐彭殇为妄作。后之视今，亦犹今之视昔，悲夫！故列叙时人，录其所述，虽世殊事异，所以兴怀，其致一也。后之览者，亦将有感于斯文。"
            var i = 0
        
            for c in title {
                let text = SCNText(string: c.description, extrusionDepth: 0.3)
                let node = SCNNode(geometry: text)
                node.position = SCNVector3Make(10, Float(-10+i), -10)
                i += 1
                text.font = UIFont(name: "HYa9gj", size: 1)
                scene.rootNode.addChildNode(node)
            }
            i = 0
            var textBody01ColumnCount = columnCount(x: textBody01.count, y: 15)
            
            for c in textBody01 {
                let text = SCNText(string: c.description, extrusionDepth: 0.3)
                let node = SCNNode(geometry: text)
                //node.position = SCNVector3Make(8, Float(-10+i), -10)
                text.font = UIFont(name: "HYa9gj", size: 1)
                textNodeArr.append(node)
                scene.rootNode.addChildNode(node)
            }
            
            
            
            
        }
    //MARK: -计算几列
    func columnCount(x:Int,y:Int) -> Int{
        guard x % y == 0 else {
            return Int(x / y) + 1
        }
        return Int(x / y)
    }

//        let textNode = SCNNode(geometry: text)
//        textNode.position = SCNVector3Make(0, 0, -10)
//        scene.rootNode.addChildNode(textNode)
        // 设置字体的大小
//        text.font = UIFont.systemFont(ofSize: 1)
//        text.font = UIFont(name: "REEJI-Cappuccino-RegularGB1.0", size: 1)
//        REEJI-Cappuccino-RegularGB1.0
        //JXK
//        let arr = UIFont.familyNames
//        print(arr)
//        print("测试：\(text.font.familyName)")
        
        
    
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
