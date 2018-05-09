//
//  CGFloat+sb.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

extension CGFloat{
    var i:Int { return Int(self) }
    var s:String { return "\(self)" }
    var d:Double { return Double(self) }
    var realValue:CGFloat{
        if self.isNaN {
            return 0
        }
        return self
    }
}
