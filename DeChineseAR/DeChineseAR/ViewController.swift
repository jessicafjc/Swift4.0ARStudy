//
//  ViewController.swift
//  DeChineseAR
//
//  Created by Mac on 2019/2/18.
//  Copyright © 2019 JiachenFu. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var chineseCharacterArray = ["龟","火","龙","猪","竹","马","鸟"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chineseCharacterArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath)
        let characterImage = cell.viewWithTag(1001) as! UIImageView
        characterImage.image = UIImage(named: "\(chineseCharacterArray[indexPath.item])")
        return cell
        
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选择的是\(chineseCharacterArray[indexPath.item])")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let descriptionVC = storyboard.instantiateViewController(withIdentifier: "description") as? DescriptionViewController else {  return }
        descriptionVC.tapTarget = chineseCharacterArray[indexPath.item]
        self.present(descriptionVC, animated: true, completion: nil)
        //descriptionVC.characterLabel.text = chineseCharacterArray[indexPath.item]

        
    }
    

}
