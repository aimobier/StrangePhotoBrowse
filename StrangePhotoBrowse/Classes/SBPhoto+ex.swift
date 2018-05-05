//
//  Number+ex.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Foundation

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
