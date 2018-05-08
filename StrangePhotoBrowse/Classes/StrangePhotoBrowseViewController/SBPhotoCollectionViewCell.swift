//
//  SBPhotoCollectionViewCell.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

protocol SBPhotoCollectionViewCellDelegate {
    
    /// 选中了 某个 Cell
    ///
    /// - Parameter cell: cell对象
    func cellDidSelectButtonClick(_ cell: SBPhotoCollectionViewCell)
}

class SBPhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    let selectButton = SBPhotoCollectionButton(type: .system)
    
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
