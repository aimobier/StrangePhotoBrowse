//
//  SBPhotoChoiceTableViewCell.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/6.
//

import Foundation

class SBPhotoChoiceTableViewCell: UITableViewCell {
    
    private let PICHEIGHT = 66.f
    
    /// 图片集合
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    
    /// 标题 个数 Label
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView1.clipsToBounds = true
        imageView1.layer.borderWidth = 1
        imageView1.layer.borderColor = UIColor.gray.a3.cgColor
        imageView1.contentMode = .scaleAspectFill
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        
        imageView2.clipsToBounds = true
        imageView2.layer.borderWidth = 1
        imageView2.layer.borderColor = UIColor.gray.a3.cgColor
        imageView2.contentMode = .scaleAspectFill
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        
        imageView3.clipsToBounds = true
        imageView3.layer.borderWidth = 1
        imageView3.layer.borderColor = UIColor.gray.a3.cgColor
        imageView3.contentMode = .scaleAspectFill
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(imageView3)
        self.contentView.addSubview(imageView2)
        self.contentView.addSubview(imageView1)
        
        imageView1.backgroundColor = UIColor.white
        imageView2.backgroundColor = UIColor.white
        imageView3.backgroundColor = UIColor.white
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: imageView1, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: imageView1, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: imageView1, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -14),
            NSLayoutConstraint(item: imageView1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PICHEIGHT),
            NSLayoutConstraint(item: imageView1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PICHEIGHT)
            ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: imageView2, attribute: .top, relatedBy: .equal, toItem: imageView1, attribute: .top, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: imageView2, attribute: .left, relatedBy: .equal, toItem: imageView1, attribute: .left, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: imageView2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PICHEIGHT),
            NSLayoutConstraint(item: imageView2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PICHEIGHT)
            ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: imageView3, attribute: .top, relatedBy: .equal, toItem: imageView2, attribute: .top, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: imageView3, attribute: .left, relatedBy: .equal, toItem: imageView2, attribute: .left, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: imageView3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PICHEIGHT),
            NSLayoutConstraint(item: imageView3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PICHEIGHT)
            ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: imageView3, attribute: .right, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: imageView1, attribute: .centerY, multiplier: 1, constant: -10),
            ])
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(countLabel)
        self.contentView.addConstraints([
            NSLayoutConstraint(item: countLabel, attribute: .left, relatedBy: .equal, toItem: imageView3, attribute: .right, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: countLabel, attribute: .centerY, relatedBy: .equal, toItem: imageView1, attribute: .centerY, multiplier: 1, constant: 10),
            ])
        
    }
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView1.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView1.image = nil
        imageView2.image = nil
        imageView3.image = nil
    }
    
    private var borderLayer: CAShapeLayer!
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if borderLayer != nil {
            return
        }
        
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: 10, y: rect.height))
        borderPath.addLine(to: CGPoint(x: rect.width-10, y: rect.height))
        
        borderLayer = CAShapeLayer()
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = UIColor(red: 224, green: 224, blue: 224).cgColor
        borderLayer.path = borderPath.cgPath
        
        self.layer.addSublayer(borderLayer)
    }
}
