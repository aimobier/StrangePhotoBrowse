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
        if let identifier = value(forKey: "uniformTypeIdentifier") as? String,identifier == kUTTypeGIF as String{
            return true
        }
        return false
    }
    
    /// 是否为视频
    var isVideo:Bool{
        return mediaType == .video
    }
    
    /// 是否横屏
    var isLandscape:Bool{
        return pixelHeight < pixelWidth
    }
    
    /// 宽 : 高
    var widthHeightScale:CGFloat{
        return pixelWidth.f/pixelHeight.f
    }
    
    /// 缩略图大小
    var thumbnailSize:CGSize{
        
        let width:CGFloat
        let height:CGFloat
        
        if isLandscape {
            width = UIScreen.main.bounds.width
            height = width/widthHeightScale
        }else{
            height = UIScreen.main.bounds.height
            width = height*widthHeightScale
        }
        return CGSize(width: width, height: height)
    }
}
