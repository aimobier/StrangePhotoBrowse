//
//  Bundle+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

extension Bundle{
    
    /// 当前的 Bundle
    static let current: Bundle = {
        let cbundle = Bundle(for: SBPhotoCollectionViewCell.classForCoder())
        if let bundleURL = cbundle.url(forResource: "StrangePhotoBrowse", withExtension: "bundle"),let bundle = Bundle(url: bundleURL)  {
            return bundle
        }
        return cbundle
    }()
}
