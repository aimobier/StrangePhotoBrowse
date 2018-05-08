//
//  SBPhotoCollectionButton.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/8.
//

import UIKit

class SBPhotoCollectionButton: UIButton{
    
    private let sbLabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        sbLabel.font = UIFont.f13.bold
        sbLabel.textAlignment = .center
        sbLabel.textColor = UIColor.white
        sbLabel.backgroundColor = SBPhotoConfigObject.share.mainColor
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
    
    func sb_setSelected(index:Int? = nil,animate:Bool = false) {
        
        if let select = index {
            
            self.setImage(SBPhotoConfigObject.share.pickerSelectedImage, for: .normal)
            
            if !SBPhotoConfigObject.share.pickerSelectIndexMode {
                
                self.sbLabel.isHidden = true
                return;
            }
            
            self.sbLabel.isHidden = false
            self.sbLabel.text = (select+1).s
            
            if animate {
                
                sbLabel.transform = sbLabel.transform.scaledBy(x: 1.2, y: 1.4)
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    self.sbLabel.transform = .identity
                })
            }
            
        }else{
            
            self.sbLabel.isHidden = true
            self.setImage(SBPhotoConfigObject.share.pickerDefaultImage, for: .normal)
        }
    }
}
