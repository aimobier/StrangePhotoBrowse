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
        
        
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        (0..<assetCollections.count).forEach(){ print(assetCollections.object(at: $0).localizedTitle) }
    }

    @IBAction func click(_ sender: Any) {
        
        self.present(SBPhotoCollectionViewController(), animated: true, completion: nil)
    }
}

