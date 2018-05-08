//
//  SBPhotoCollectionViewCell.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

class SBphotoCollectionButtin: UIButton{
    
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

protocol SBPhotoCollectionViewCellDelegate {
    
    /// 选中了 某个 Cell
    ///
    /// - Parameter cell: cell对象
    func cellDidSelectButtonClick(_ cell: SBPhotoCollectionViewCell)
}

class SBPhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    let selectButton = SBphotoCollectionButtin(type: .system)
    
    var delegate:SBPhotoCollectionViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            ])
        
        
        selectButton.addTarget(self, action: #selector(selectButtonClick), for: UIControlEvents.touchUpInside)
        selectButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectButton)
        contentView.addConstraints([
            NSLayoutConstraint(item: selectButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectButton, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            ])
    }
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    @objc func selectButtonClick()  {
        
        self.delegate?.cellDidSelectButtonClick(self)
    }
}
