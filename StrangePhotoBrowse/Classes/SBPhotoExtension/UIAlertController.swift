//
//  UIAlertController.swift
//  FLAnimatedImage
//
//  Created by 荆文征 on 2018/5/10.
//

import UIKit

extension UIAlertController{
    
    /// 在指定的 UIViewController 弹出 UIAlertController 视图
    ///
    /// - Parameters:
    ///   - vc: 指定的视图
    ///   - message: 弹出的消息
    static func show(_ vc:UIViewController,message:String){
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "我知道了", style: UIAlertActionStyle.cancel, handler: nil))
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
