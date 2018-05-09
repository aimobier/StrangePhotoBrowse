//
//  ViewController.swift
//  StrangePhotoBrowse
//
//  Created by 200739491@qq.com on 05/05/2018.
//  Copyright (c) 2018 200739491@qq.com. All rights reserved.
//

import UIKit
import Photos
import StrangePhotoBrowse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SBPhotoConfigObject.share.showGifInCollectionMainView = true
        SBPhotoConfigObject.share.mainColor = UIColor(red: 26/255.0, green: 178/255.0, blue: 10/255.0, alpha: 1)
        SBPhotoConfigObject.share.collectionViewBackViewBackgroundColor = UIColor.white
    }

    @IBAction func click(_ sender: Any) {
        
        self.present(StrangePhotoViewController(), animated: true, completion: nil)
    }
}

