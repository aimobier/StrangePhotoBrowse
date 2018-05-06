//
//  SBPhotoCollectionToolBarView.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

class SBPhotoCollectionNavBarView: UIView {
    
    let titleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: .zero)
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ])
    }
}

class SBPhotoCollectionNavBarView: UIView {
    
    private let button = UIButton(type: .system)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: .zero)
        
//        self.
    }
}

/// 相册内没有更多照片展示的空白展位图
class SBPhotoEmptyView: UIView{
    
    let titleLabel = UILabel()
    let subTittleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(_ title: NSAttributedString,subTitle:NSAttributedString) {
        
        super.init(frame: .zero)
        
        titleLabel.attributedText = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            ])
        
        subTittleLabel.attributedText = subTitle
        subTittleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subTittleLabel)
        self.addConstraints([
            NSLayoutConstraint(item: subTittleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: subTittleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            ])
    }
}
