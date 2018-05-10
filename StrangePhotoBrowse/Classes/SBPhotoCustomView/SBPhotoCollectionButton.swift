//
//  SBPhotoCollectionButton.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

/// 相册 选择按钮 对象
/// 该对象主要 来 表示 PHAsset 对象是否被用户选中
class SBPhotoCollectionButton: UIButton{
    
    /// 选择顺序Index 展示 视图
    private let sbLabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        /// 开发者 选择关闭 Index 展示
        if !SBPhotoConfigObject.share.pickerSelectIndexMode {
            
            /// 不需要做更多的配置
            return
        }
        
        sbLabel.font = UIFont.f13.bold
        sbLabel.textAlignment = .center
        sbLabel.textColor = UIColor.white
        sbLabel.backgroundColor = SBPhotoConfigObject.share.mainColor // 将该视图的背景色设置为 开发者 设置的默认主题色
        sbLabel.layer.cornerRadius = 13
        sbLabel.clipsToBounds = true
        self.addSubview(sbLabel)
        sbLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            
            NSLayoutConstraint(item: sbLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 26),
            NSLayoutConstraint(item: sbLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 26),
            NSLayoutConstraint(item: sbLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sbLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 将此按钮 按照 状态进行配置
    ///
    /// - Parameters:
    ///   - index: Option 对象 Index 根据该对象进行是否显示
    ///   - animate: 是否以动画方式来改变此状态
    func sb_setSelected(index:Int? = nil,animate:Bool = false) {
        
        if let select = index { // 选中操作
            
            if !SBPhotoConfigObject.share.pickerSelectIndexMode { // 不显示 Index 方式配置
                
                self.setImage(SBPhotoConfigObject.share.pickerSelectedImage, for: .normal)
                
                return self.sbLabel.isHidden = true
            }
            
            self.sbLabel.isHidden = false
            
            self.sbLabel.text = (select+1).s
            
            if animate { // 需要动画
                
                sbLabel.transform = sbLabel.transform.scaledBy(x: 1.2, y: 1.4)
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { // Spring 弹性动画
                    
                    self.sbLabel.transform = .identity
                })
            }
            
        }else{ // 取消选中操作
            
            self.sbLabel.isHidden = true
            
            self.setImage(SBPhotoConfigObject.share.pickerDefaultImage, for: .normal)
        }
    }
}
