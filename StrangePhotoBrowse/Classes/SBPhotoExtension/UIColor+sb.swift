//
//  UIColor+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

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
