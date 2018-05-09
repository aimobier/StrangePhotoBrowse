//
//  UIButton+sb.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/9.
//

import UIKit

extension UIButton{
    
    /// 设置Button 中间的 Space
    ///
    /// - Parameter spacing: 中间的距离
    func centerButtonAndImageWithSpace(_ spacing:CGFloat)  {
        
        let insetAmount = spacing / 2
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
