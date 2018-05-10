//
//  UIImage+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

/// 获取一个 当前 Bundle curren 中的一张图片
///
/// - Parameters:
///   - name: 图片名称
///   - color: 图片颜色
/// - Returns: 图片对象
func SBImageMake(_ name:String,color:UIColor? = nil) -> UIImage?{
    return UIImage.image(name, color: color)
}

extension UIImage{
    
    /// 图片 根据 颜色生成相对应的图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    func imageBy(_ color:UIColor) -> UIImage? {
        
        let image = self
        
        let backgroundSize = image.size
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        var backgroundRect=CGRect()
        backgroundRect.size = backgroundSize
        backgroundRect.origin.x = 0
        backgroundRect.origin.y = 0
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        ctx.setFillColor(red: r, green: g, blue: b, alpha: a)
        ctx.fill(backgroundRect)
        
        var imageRect = CGRect()
        imageRect.size = image.size
        imageRect.origin.x = (backgroundSize.width - image.size.width) / 2
        imageRect.origin.y = (backgroundSize.height - image.size.height) / 2
        
        // Unflip the image
        ctx.translateBy(x: 0, y: backgroundSize.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        ctx.setBlendMode(.destinationIn)
        ctx.draw(image.cgImage!, in: imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据名称 以及 颜色 生成 UIimage
    ///
    /// - Parameters:
    ///   - name: 图片名称
    ///   - color: 颜色
    ///   - noColor: 不需要 tintColor
    /// - Returns: 图片对象
    static func image(_ name:String,color:UIColor? = nil,noColor:Bool=true) -> UIImage?{
        
        var image = UIImage(named: name, in: Bundle.current, compatibleWith: nil)
        if noColor {
            image = image?.withRenderingMode(.alwaysOriginal)
        }
        if let col = color {
            return image?.imageBy(col)
        }
        return image
    }
    
    /// 通过颜色创建一张图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 图片对象
    static func create(color: UIColor, size: CGSize = CGSize(width: 1, height: 1),cornerRadius: CGFloat=0) -> UIImage{
        /// The base rectangle of the image.
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        /// The graphics context of the image.
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        /// Image that will be retured.
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(size)
        
        UIBezierPath(roundedRect: rect, cornerRadius:cornerRadius).addClip()
        image?.draw(in: rect)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
