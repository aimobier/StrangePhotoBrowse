//
//  SBPhotoChoiceTableBackView.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

class SBPhotoChoiceTableBackView: UIView{
    
    var maskLayer: CAShapeLayer!
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if maskLayer != nil { return }
        
        maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        
        self.layer.mask = maskLayer
    }
}
