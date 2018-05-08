//
//  String+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

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
