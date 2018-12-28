//
//  TextModel.swift
//  Classical-Chinese-Junior
//
//  Created by Mac on 2018/12/26.
//  Copyright © 2018 JessicaFuMac. All rights reserved.
//

class TextModel {
    var titleText:String?
    var authorText:String?
    var contenttText:String?
    var textString:String?
    func setTextString() -> String{
        textString = titleText!+authorText!+contenttText!
        return textString!
    }
//    var titleText = "江雪"
//    var authorText = "柳宗元"
//    var contenttText = "江雪柳宗元千山鸟飞绝，万径人踪灭。孤舟蓑笠翁，独钓寒江雪。"
//    var textString = titleText + authorText + contenttText
}
