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

@objc protocol SBPhotoCollectionToolBarViewDelegate {
    
    /// 当点击预览按钮
    ///
    /// - Parameter button: 预览按钮
    @objc optional func didClickPreviewButton(button: UIButton)
    
    /// 当点击原图按钮
    ///
    /// - Parameter button: 原图按钮
    @objc optional func didClickOriginalButton(button: UIButton)
    
    /// 当点击选择按钮
    ///
    /// - Parameter button: 选择按钮
    @objc optional func didClickChoiceButton(button: UIButton)
    
    
    /// 当点击返回按钮
    ///
    /// - Parameter button: 选择按钮
    @objc optional func didClickCancelButton(button: UIButton)
}

class SBPhotoCollectionToolBarView: UIView {
    
    var delegate:SBPhotoCollectionToolBarViewDelegate?
    
    /// 预览按钮
    let previewButton = UIButton(type: .system)
    
    /// 原图按钮
    let originalButton = UIButton(type: .system)
    
    /// 选择按钮
    let choiceButton = UIButton(type: .system)
    
    /// 返回按钮
    let cancelButton = UIButton(type: .system)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    enum SBPhotoCollectionToolBarStyle{
        case normal
        case choice
    }
    
    init(_ style: SBPhotoCollectionToolBarStyle = .normal) {
        
        super.init(frame: .zero)
        
        switch style {
        case .normal: makeNormal()
        case .choice: makeChoice()
        }
    }
    
    func makeChoice(){
        
        self.cancelButton.setAttributedTitle("返回".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold), for: .normal)
        self.cancelButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cancelButton)
        self.addConstraints([
            NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.cancelButton.addTarget(self, action: #selector(didClickCancelButton(button:)), for: .touchUpInside)
    }
    
    func makeNormal(){
        
        self.choiceButton.setAttributedTitle("全部照片".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold), for: .normal)
        self.choiceButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.choiceButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(choiceButton)
        self.addConstraints([
            NSLayoutConstraint(item: choiceButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: choiceButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: choiceButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.previewButton.setAttributedTitle("预览".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold), for: .normal)
        self.previewButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.previewButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(previewButton)
        self.addConstraints([
            NSLayoutConstraint(item: previewButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: previewButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.originalButton.setAttributedTitle("原图".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold), for: .normal)
        self.originalButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.originalButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(originalButton)
        self.addConstraints([
            NSLayoutConstraint(item: originalButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: originalButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: originalButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.choiceButton.addTarget(self, action: #selector(didClickChoiceButton(button:)), for: .touchUpInside)
        self.previewButton.addTarget(self, action: #selector(didClickPreviewButton(button:)), for: .touchUpInside)
        self.originalButton.addTarget(self, action: #selector(didClickOriginalButton(button:)), for: .touchUpInside)
    }
    
    @objc func didClickPreviewButton(button: UIButton){
        
        guard let method =  self.delegate?.didClickPreviewButton else{ return }
        
        method(button)
    }
    
    @objc func didClickOriginalButton(button: UIButton){
        
        guard let method =  self.delegate?.didClickOriginalButton else{ return }
        
        method(button)
    }
    
    @objc func didClickChoiceButton(button: UIButton){
        
        guard let method =  self.delegate?.didClickChoiceButton else{ return }
        
        method(button)
    }
    
    @objc func didClickCancelButton(button: UIButton){
        
        guard let method =  self.delegate?.didClickCancelButton else{ return }
        
        method(button)
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

