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
