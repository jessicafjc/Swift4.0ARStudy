//
//  DescriptionViewController.swift
//  DeChineseAR
//
//  Created by Mac on 2019/2/19.
//  Copyright © 2019 JiachenFu. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController ,UINavigationControllerDelegate{

    @IBOutlet weak var GifView: GifView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var BgImage: UIImageView!
    var tapTarget = ""  //点击传值
    
    @IBAction func backBtn() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ARBtn() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let ARviewC = storyboard.instantiateViewController(withIdentifier: "description") as? DescriptionViewController else {  return }
        ARviewC.tapTarget = tapTarget
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(tapTarget)
        BgImage.image = UIImage(named: tapTarget + "_bg")
        characterLabel.text = tapTarget
        GifView.contentMode = UIView.ContentMode.scaleAspectFit
        gifShow()
      
    }
    
    func gifShow(){
        GifView.gifName = tapTarget
        GifView.showGIFImageWithLocalName(name: "")

    }

}
