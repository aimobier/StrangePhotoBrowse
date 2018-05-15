//
//  SBPhotoCollectionToolBarView.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

/// ToolBarView Delegate
@objc protocol SBPhotoCollectionToolBarViewDelegate {
    
    /// ToolBarView 点击预览按钮
    @objc optional func didClickPreviewButton(button: UIButton)
    
    /// ToolBarView 点击原图按钮
    @objc optional func didClickOriginalButton(button: UIButton)
    
    /// ToolBarView 点击选择按钮
    @objc optional func didClickChoiceButton(button: UIButton)
    
    /// ToolBarView 点击返回按钮
    @objc optional func didClickCancelButton(button: UIButton)
    
    /// ToolBarView 点击返回按钮
    @objc optional func didClickSelectButton(button: SBPhotoCollectionButton)
}

class SBPhotoCollectionToolBarView: UIView {
    
    weak var delegate:SBPhotoCollectionToolBarViewDelegate?
    
    /// 预览按钮
    let previewButton = UIButton(type: .system)
    
    /// 原图按钮
    let originalButton = UIButton(type: .system)
    
    /// 选择按钮
    let choiceButton = UIButton(type: .system)
    
    /// 返回按钮
    let cancelButton = UIButton(type: .system)
    
    /// 选中按钮
    let selectButton = SBPhotoCollectionButton(type: .system)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    /// ToolBarView 配置方式
    ///
    /// - normal: 默认的配置
    /// - choice: 选择视图的 ToolBarView 配置
    /// - preview: 预览视图的 ToolBarView 配置
    enum SBPhotoCollectionToolBarStyle{
        case normal
        case choice
        case preview
    }
    
    init(_ style: SBPhotoCollectionToolBarStyle = .normal) {
        
        super.init(frame: .zero)
        
        switch style {
        case .normal: makeNormal()
        case .choice: makeChoice()
        case .preview: makePreview()
        }
    }
    
    func makeChoice(){
        
        cancelButtonMethod()
    }
    
    func makeNormal(){
        
        choiceButtonMethod()
        previewButtonMethod()
        originalButtonMethod()
    }
    
    func makePreview(){
        
        originalButtonMethod()
        selectButtonMethod()
    }
}

// MARK: - Layout and Button's Action Methods
extension SBPhotoCollectionToolBarView{
    
    private func cancelButtonMethod() {
        
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
    
    private func previewButtonMethod(){
        
        self.previewButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.previewButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(previewButton)
        self.previewButton.setAttributedTitle("预览".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor.a3).withFont(UIFont.f13.bold), for: .disabled)
        self.addConstraints([
            NSLayoutConstraint(item: previewButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: previewButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: previewButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.previewButton.addTarget(self, action: #selector(didClickPreviewButton(button:)), for: .touchUpInside)
    }
    
    private func choiceButtonMethod(){
        
        self.choiceButton.setAttributedTitle("全部照片".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold), for: .normal)
        self.choiceButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.choiceButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(choiceButton)
        self.addConstraints([
            NSLayoutConstraint(item: choiceButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: choiceButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: choiceButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.choiceButton.addTarget(self, action: #selector(didClickChoiceButton(button:)), for: .touchUpInside)
    }
    
    private func originalButtonMethod(){
        
        self.originalButton.setAttributedTitle("原图".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f10.bold), for: .normal)
        self.originalButton.centerButtonAndImageWithSpace(4)
        self.originalButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(originalButton)
        self.addConstraints([
            NSLayoutConstraint(item: originalButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: originalButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: originalButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.originalButton.addTarget(self, action: #selector(didClickOriginalButton(button:)), for: .touchUpInside)
    }
    
    private func selectButtonMethod(){
        
        self.selectButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        self.selectButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectButton)
        self.selectButton.setImage(SBPhotoConfigObject.share.pickerDefaultImage, for: .normal)
        self.addConstraints([
            NSLayoutConstraint(item: selectButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: selectButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.selectButton.addTarget(self, action: #selector(didClickSelectButton(button:)), for: .touchUpInside)
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
    
    @objc func didClickSelectButton(button: SBPhotoCollectionButton){
     
        guard let method =  self.delegate?.didClickSelectButton else{ return }
        
        method(button)
    }
}
