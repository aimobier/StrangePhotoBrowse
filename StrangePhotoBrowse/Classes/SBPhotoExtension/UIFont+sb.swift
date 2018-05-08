//
//  UIFont+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

extension UIFont{
    
    static let f10: UIFont = {
        return UIFont.systemFont(ofSize: 10)
    }()
    
    static let f13: UIFont = {
        return UIFont.systemFont(ofSize: 13)
    }()
    
    static let f15: UIFont = {
        return UIFont.systemFont(ofSize: 15)
    }()
    
    static let f17: UIFont = {
        return UIFont.systemFont(ofSize: 17)
    }()
    
    private func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        if let descriptor = fontDescriptor.withSymbolicTraits(traits){
            return UIFont(descriptor: descriptor, size: 0)
        }
        return self //size 0 means keep the size as it is
    }
    
    /// 获取字体的加粗字体
    var bold: UIFont {
        return withTraits(traits: .traitBold)
    }
    
    /// 获取字体的斜体字体
    var italic: UIFont {
        return withTraits(traits: .traitBold)
    }
}
