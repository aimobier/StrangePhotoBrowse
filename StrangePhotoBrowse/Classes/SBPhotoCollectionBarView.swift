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
