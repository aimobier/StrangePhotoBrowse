//
//  PHAsset+sb.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/9.
//

import Photos
import MobileCoreServices

extension PHAsset{
    
    var isGif:Bool{
        if let identifier = self.value(forKey: "uniformTypeIdentifier") as? String,identifier == kUTTypeGIF as String{
            return true
        }
        return false
    }
}
