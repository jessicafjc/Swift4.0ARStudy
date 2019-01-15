# ARKit 学习笔记
 
 - author: 傅佳晨
 - since: 19-01-03 14:00:00
 - version:1.0
 - Swift 4.2 Xcode MacBook Air
 
[基本概念](#markdown-first)

[常用参数、代码片段](#markdown-code)

## <a name="markdown-first"></a>基本概念

**坐标系**

![](http://bmob-cdn-21468.b0.upaiyun.com/2019/01/15/01a309c04014ead280e2efea7b30ab97.png)

## <a name="markdown-second"></a>Materials

![](https://upload-images.jianshu.io/upload_images/1806489-869fb56e94fbed04.png)

* Diffuse map(颜色贴图,漫反射贴图):给几何体一个基本的颜色纹理,不考虑灯光和特效:
* Normal map(法线贴图):在上篇文章的灯光里讲过,灯光是使用形状表面的法向量来决定照亮哪个面的.系统自带形状是使用单一的整个面的向量,而法线贴图则以RGB值定义了精确到每个像素的法向量,这样每个像素对灯光的反应都不同,形成表面崎岖不平的灯光效果
* Reflective map(反射贴图):以黑白图片精确定义了材质每个像素的反光程度.就是周围环境的光线在物体表面映射出的图像(实际就是天空盒子图像在物体表面的反光).
* Occlusion map(闭塞贴图):也就是ambient occlusion map(AO贴图,环境光闭塞贴图),只有当场景中有ambient light环境光时才有作用,精确定义了每个像素在环境光作用下的被照亮程度.也就是让几何体的黑色部分不被环境光照亮而变浅
* Specular map(镜面贴图,高光贴图):镜面贴图决定了几何体的镜面程度,黑色部分就是不光滑,白色就是光滑反光.会影响Normal map(法线贴图)外部光线照射反光和Reflective map(反射贴图)外部天空盒子图像反光的清晰程度
* Emission map(发光贴图):在没有光线时,如果物体表面有荧光涂料,就会发光.发光贴图可以用来模拟这种物体.彩色贴图中,黑色不发光,亮色发光强,暗色发光弱。
**需要注意的是**在Scene Kit中Emission map(发光贴图)并不真正发光,只是模拟发光效果而已.就是说不能照亮其他物体,不能产生阴影.这点与其他3D创作工具不同.
* Multiply map(乘法贴图,正片叠底贴图):会影响其他所有效果.一般用来给最后的效果调整色彩或者亮度
* Transparency map(透明贴图):黑色部分不透明,白色透明.**注意:**球体内部需要开启double-sided mode才能看到
* Metalness and Roughness maps(光泽度和粗糙度贴图):Xcode8引入的新特性,Physically Based Rendering (PBR)灯光模型可以使用Metalness和Roughness贴图.

参考[《3D Apple Games by Tutorials》](https://www.jianshu.com/p/936752aff5a3)

相关代码[Github](https://github.com/jessicafjc/3D-iOS-Games-by-Tutorials-code)

## <a name="markdown-code"></a>常用参数、代码片段

**设立一个空场景**

    var scene: SCNScene!
 
**设立一个cameraNode节点作为相机节点**

    var cameraNode: SCNNode!


**添加场景**

```
 func setupScene() {
        // Set the view's delegate
        sceneView.delegate = self
        // Create a new scene
        scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //是否可以移动相机节点
        sceneView.allowsCameraControl = true
        //添加均匀光
        sceneView.autoenablesDefaultLighting = true
        
    }
```

**添加相机节点**

```
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
```
**添加指定场景内的节点**

    func createNode(){
        //获取scn
        let role = "lan"
        guard let portalScene = SCNScene(named: "art.scnassets/\(role).scn") else {return}
        //获取scn的指定节点
        let roleNode = portalScene.rootNode.childNode(withName: "lan", recursively: true)
        roleNode!.position = SCNVector3(0,0,-5)
        roleNode!.name = role
        scene.rootNode.addChildNode(roleNode!)
    }
    
**多字体循环添加文字节点**

    func fontFamilyNode(){
        var nodeArr = [SCNNode]()
        //字体数组
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

**单字体多字循环添加**

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

**文字行列排版：x为需要排版的字数，y为一行的字数，return最终的行数**

    func columnCount(x:Int,y:Int) -> Int{
        guard x % y == 0 else {
            return Int(x / y) + 1
        }
        return Int(x / y)
    }


**点击节点事件**

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
   
**计时器事件**
   
     var spawnTime: TimeInterval = 0
     func renderer(_ renderer: SCNSceneRenderer, updateAtTime time:
        TimeInterval) {
        
        if time > spawnTime {
            guard nodeIndex < textNodeArr.count else { return }
            scene.rootNode.addChildNode(textNodeArr[nodeIndex])
            nodeIndex += 1
            spawnTime = time + TimeInterval(0.5)
        }
        
    }
    
   **图像识别事件**
   
   重写`viewWillAppear(_ animated: Bool)`这个函数
   
       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        //获取AR的资源组名称
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Images", bundle: nil) else {
            return
        }
        configuration.trackingImages = arImages
        // Run the view's session
        sceneView.session.run(configuration)
    }
   
在`renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {}`中进行具体操作
      
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let referenceImage = imageAnchor.referenceImage
			//判断图像是否识别成功
        if (referenceImage.name != nil) {
        print("referenceImage.name : \(String(describing: referenceImageName))")
        //获取识别图像的真实大小
            let imageWidth = referenceImage.physicalSize.width
            let imageHeight = referenceImage.physicalSize.height
            //var setNode = setRecogmizedNode(referenceImageName: referenceImage.name!)
          
        }
        
    }
    
**添加粒子效果**

	//particleName：.scnp文件名称，addNode：需要添加到的节点
    func setParticle(particleName:String,addNode:SCNNode){
    let particle = SCNParticleSystem(named: "\(particleName).scnp", inDirectory: nil)!
    addNode.addParticleSystem(particle)
	}
**清空场景的节点**

    func cleanScene() {
        for node in scene.rootNode.childNodes {
            
            node.removeFromParentNode()
            
        }
    }    
    
 **节点添加动画效果**

	let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
	//永远循环
	let repeatAction = SCNAction.repeatForever(action)
	//将动作添加至`node`节点
	node.runAction(SCNAction.sequence([SCNAction.wait(duration:0.5),
		SCNAction.scale(to:0.002,duration:1.5)]))
		
		
****
****