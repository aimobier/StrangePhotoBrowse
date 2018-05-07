//
//  SBPhoto+ex.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

extension Int{
    var s:String { return "\(self)" }
    var d:Double { return Double(self) }
    var f:CGFloat { return CGFloat(self) }
}

extension Double{
    var i:Int { return Int(self) }
    var s:String { return "\(self)" }
    var f:CGFloat { return CGFloat(self) }
}

extension CGFloat{
    var i:Int { return Int(self) }
    var s:String { return "\(self)" }
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
    
    /// 随机颜色
    static var randColor:UIColor{
        return UIColor(hue: drand48().f, saturation: drand48().f, brightness: drand48().f, alpha: 1)
    }
    
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
    
    var a0: UIColor { return self.withAlphaComponent(0) }
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


extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

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
    
    func imageBy(_ color:UIColor) -> UIImage? {
        
        guard let cgimage = self.cgImage else { return self }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.clip(to: rect, mask: cgimage)
        color.setFill()
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func image(_ name:String,color:UIColor? = nil) -> UIImage?{
        
        let image = UIImage(named: name, in: Bundle.current, compatibleWith: nil)
        if let col = color {
            return image?.imageBy(col)
        }
        return image
    }
}

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
