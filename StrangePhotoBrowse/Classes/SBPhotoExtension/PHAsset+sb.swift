//
//  PHAsset+sb.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/9.
//

import Photos
import MobileCoreServices

extension PHAsset{
    
    /// 是否为 gif
    var isGif:Bool{
        if let identifier = self.value(forKey: "uniformTypeIdentifier") as? String,identifier == kUTTypeGIF as String{
            return true
        }
        return false
    }
    
    /// 是否为视频
    var isVideo:Bool{
        return self.mediaType == .video
    }
}
