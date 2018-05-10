//
//  SBPhotoCollectionNavBarView.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

@objc protocol SBPhotoCollectionNavBarViewDelegate {
    
    /// 点击返回按钮
    @objc optional func didClickCancelButton(button:UIButton)
    
    /// 点击 SubMit 按钮
    @objc optional func didClickSubmitButton(button:UIButton)
    
    /// 点击 close 按钮
    @objc optional func didClickCloseButton(button:UIButton)
}

class SBPhotoCollectionNavBarView: UIView {
    
    let titleLabel = UILabel()
    
    let calcelButton = UIButton(type: .system)
    
    let submitButton = UIButton(type: .system)
    
    let closeButton = UIButton(type: .system)
    
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
        
        switch style {
        case .normal: makeNormal()
        case .cancel: makeCancel()
        }
    }
    
    private func makeCancel(){
        
        self.titleLabelMethod()
        self.cancelButtonMethod()
        self.submitButtonMethod()
    }
    
    private func makeNormal(){
        
        self.closeButtonMethod()
        self.titleLabelMethod()
        self.submitButtonMethod()
    }
}


extension SBPhotoCollectionNavBarView{
    
    func titleLabelMethod()  {
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ])
    }
    
    func submitButtonMethod()  {
        
        addSubview(submitButton)
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 4
        submitButton.setBackgroundImage(UIImage.create(color: SBPhotoConfigObject.share.mainColor), for: .normal)
        submitButton.setBackgroundImage(UIImage.create(color: SBPhotoConfigObject.share.mainColor.a4), for: .disabled)
        submitButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        submitButton.setAttributedTitle("发送".withTextColor(.white).withFont(UIFont.f13.bold), for: .normal)
        submitButton.setAttributedTitle("发送".withTextColor(UIColor.white.a4).withFont(UIFont.f13.bold), for: .disabled)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: submitButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: submitButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 27),
            ])
        self.submitButton.addTarget(self, action: #selector(didClickSubmitButton(button:)), for: UIControlEvents.touchUpInside)
    }
    
    func cancelButtonMethod(){
        
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
    
    func closeButtonMethod(){
        
        self.addSubview(self.closeButton)
        closeButton.setAttributedTitle("关闭".withTextColor(SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor).withFont(UIFont.f13.bold), for: .normal)
        closeButton.tintColor = SBPhotoConfigObject.share.navBarViewToolViewTitleTextColor
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: closeButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: closeButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44),
            ])
        self.closeButton.addTarget(self, action: #selector(didClickCloseButton(button:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func didClickCancelButton(button:UIButton){
        
        guard let method =  self.delegate?.didClickCancelButton else{ return }
        
        method(button)
    }
    
    @objc func didClickSubmitButton(button:UIButton){
        
        guard let method =  self.delegate?.didClickSubmitButton else{ return }
        
        method(button)
    }
    
    @objc func didClickCloseButton(button:UIButton){
        
        guard let method =  self.delegate?.didClickCloseButton else{ return }
        
        method(button)
    }
}
