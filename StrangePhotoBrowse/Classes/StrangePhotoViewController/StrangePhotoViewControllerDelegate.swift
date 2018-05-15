//
//  StrangePhotoViewControllerDelegate.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/14.
//

import Photos
import Foundation

@objc public protocol StrangePhotoViewControllerDelegate {
    
    
    /// 用户点击发送 这个时候开始处理图片 在 didFinish 处理完毕
    @objc optional func willFinish()
    
    /// 用户确认完成
    ///
    /// - Parameters:
    ///   - images: 图片结合
    ///   - resources: 资源集合
    @objc optional func didFinish(images:[UIImage],resources:[PHAsset])
    
    /// 用户确认返回
    @objc optional func didCancel()
}
