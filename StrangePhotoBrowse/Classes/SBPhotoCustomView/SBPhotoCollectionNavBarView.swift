//
//  SBPhotoCollectionNavBarView.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

protocol SBPhotoCollectionNavBarViewDelegate {
    
    /// 点击返回按钮
    func didClickCancelButton(button:UIButton)
}

class SBPhotoCollectionNavBarView: UIView {
    
    let titleLabel = UILabel()
    
    let calcelButton = UIButton(type: .system)
    
    var delegate:SBPhotoCollectionNavBarViewDelegate?
    
    enum NavgationBarStyle{
        case normal
        case cancel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(_ style: NavgationBarStyle = .normal) {
        
        super.init(frame: .zero)
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        
        if style == .cancel {
            
            self.addSubview(self.calcelButton)
            calcelButton.setImage(SBImageMake("navi_back"), for: UIControlState.normal)
            calcelButton.tintColor = SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor
            self.calcelButton.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: calcelButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: calcelButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: calcelButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: calcelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44),
                ])
            self.calcelButton.addTarget(self, action: #selector(didClickCancelButton(button:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    @objc func didClickCancelButton(button:UIButton){
        
        self.delegate?.didClickCancelButton(button: button)
    }
}

