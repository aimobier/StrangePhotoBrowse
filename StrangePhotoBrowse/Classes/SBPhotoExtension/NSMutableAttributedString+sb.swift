//
//  NSMutableAttributedString+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

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
