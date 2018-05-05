//
//  SBPhotoCollectionViewCell.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import UIKit

class SBPhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0),
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
}
