//
//  SBPhoto+ex.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

extension Int{
    var d:Double { return Double(self) }
    var f:CGFloat { return CGFloat(self) }
}

extension Double{
    var i:Int { return Int(self) }
    var f:CGFloat { return CGFloat(self) }
}

extension CGFloat{
    var i:Int { return Int(self) }
    var d:Double { return Double(self) }
}


extension String{
    
    /// Set Font
    func withFont(_ font:UIFont) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font : font])
    }
    
    /// Set TextColor
    func withTextColor(_ textColor:UIColor) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.foregroundColor : textColor])
    }
}

extension NSMutableAttributedString{
    
    /// Set Font
    func withFont(_ font:UIFont) -> NSMutableAttributedString {
        let mutable = mutableCopy() as! NSMutableAttributedString
        mutable.addAttribute(.font, value: font, range: NSRange(location: 0, length: length))
        return mutable
    }
    
    /// Set TextColor
    func withTextColor(_ textColor:UIColor) -> NSMutableAttributedString {
        let mutable = mutableCopy() as! NSMutableAttributedString
        mutable.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: length))
        return mutable
    }
}

extension UIFont{

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

extension UIColor{
    
    /// 根据 红 绿 蓝 创建颜色
    ///
    /// - Parameters:
    ///   - red: 0-255 之间的数值
    ///   - green: 0-255 之间的数值
    ///   - blue: 0-255 之间的数值
    ///   - a: 透明度
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    /// 根据 hex 16禁止数值 获取颜色
    ///
    /// - Parameters:
    ///   - rgb: 16进制颜色
    ///   - a: 透明度
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    
    var a1: UIColor { return self.withAlphaComponent(0.1) }
    var a2: UIColor { return self.withAlphaComponent(0.2) }
    var a3: UIColor { return self.withAlphaComponent(0.3) }
    var a4: UIColor { return self.withAlphaComponent(0.4) }
    var a5: UIColor { return self.withAlphaComponent(0.5) }
    var a6: UIColor { return self.withAlphaComponent(0.6) }
    var a7: UIColor { return self.withAlphaComponent(0.7) }
    var a8: UIColor { return self.withAlphaComponent(0.8) }
    var a9: UIColor { return self.withAlphaComponent(0.9) }
}

