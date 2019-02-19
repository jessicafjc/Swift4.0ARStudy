//
//  GifView.swift
//  DeChineseAR
//
//  Created by Mac on 2019/2/19.
//  Copyright © 2019 JiachenFu. All rights reserved.
//

import UIKit

class GifView: UIView {
    var width:CGFloat{return self.frame.size.width}
    var height:CGFloat{return self.frame.size.height}
    private var gifurl:NSURL! // 把本地图片转化成URL
    private var imageArr:Array<CGImage> = [] // 图片数组(存放每一帧的图片)
    private var timeArr:Array<NSNumber> = [] // 时间数组(存放每一帧的图片的时间)
    private var totalTime:Float = 0 // gif动画时间
    var gifName:String!
    /**
     *  加载本地GIF图片
     */
    func showGIFImageWithLocalName(name:String) {
        gifurl = Bundle.main.url(forResource: gifName, withExtension: "gif") as NSURL!
        //print(gifName)
        //print(gifurl)
        self.creatKeyFrame()
    }
    
    /**
     *  获取GIF图片的每一帧 有关的东西  比如：每一帧的图片、每一帧的图片执行的时间
     */
    func creatKeyFrame() {
        var CFurl:CFURL = gifurl! as CFURL
        //print(CFurl)
        var gifSource = CGImageSourceCreateWithURL(CFurl, CFDictionary?.none)
        var imageCount = CGImageSourceGetCount(gifSource!)
        
        for i in 0..<imageCount {
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil) // 取得每一帧的图片
            imageArr.append(imageRef!)
            
            
            let sourceDict = CGImageSourceCopyPropertiesAtIndex(gifSource!, i, nil) as NSDictionary!
            //let gifDict = sourceDict?[String(kCGImagePropertyGIFDictionary)]
            let time = 0.1 as! NSNumber// 每一帧的动画时间
            timeArr.append(time)
            totalTime += time.floatValue
            
            // 获取图片的尺寸 (适应)
            let imageWitdh = sourceDict?[String(kCGImagePropertyPixelWidth)] as! NSNumber
            let imageHeight = sourceDict?[String(kCGImagePropertyPixelHeight)] as! NSNumber
            if ((imageWitdh.floatValue)/(imageHeight.floatValue) != Float((width)/(height))) {
                self.fitScale(imageWitdh: CGFloat(imageWitdh.floatValue), imageHeight: CGFloat(imageHeight.floatValue))
            }
        }
        
        self.showAnimation()
    }
    
    /**
     *  (适应)
     */
    private func fitScale(imageWitdh:CGFloat, imageHeight:CGFloat) {
        var newWidth:CGFloat
        var newHeight:CGFloat
        if imageWitdh/imageHeight > width/height {
            newWidth = width
            newHeight = width/(imageWitdh/imageHeight)
        } else {
            newWidth = height/(imageHeight/imageWitdh)
            newHeight = height;
        }
        let point = self.center;
        //self.frame.size = CGSizeMake(newWidth, newHeight);
        self.frame.size = CGSize.init(width: newWidth, height:newHeight)
        self.center = point;
    }
    
    /**
     *  展示动画
     */
    private func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current:Float = 0
        var timeKeys:Array<NSNumber> = []
        
        for time in timeArr {
            timeKeys.append(NSNumber(value: current/totalTime))
            current += time.floatValue
        }
        animation.keyTimes = timeKeys
        animation.values = imageArr
        animation.repeatCount = HUGE;
        animation.duration = TimeInterval(totalTime)
        animation.isRemovedOnCompletion = false
        self.layer .add(animation, forKey: "GifView")
    }
    


}
