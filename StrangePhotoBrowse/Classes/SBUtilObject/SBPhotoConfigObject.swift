//
//  SBPhotoConfigObject.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Foundation

public class SBPhotoConfigObject {
    
    /// 默认的
    public static let share = SBPhotoConfigObject()
    
    /// UIViewControllerBasedStatusBarAppearance - View controller-based status bar appearance
    public let BaseStatusBarViewController:Bool = Bundle.main.object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as? Bool ?? true
    
    /// 主题色
    public var mainColor = UIColor(rgb: 0x3979e6)
    
    /// 每一行展示的照片数目
    public var perLineDisplayNumber = 4
    
    /// 上下方的 NavBar ToolBar Back Color
    public var navBarViewToolViewTitleTextColor = UIColor.white
    /// 上下方的 NavBar ToolBar Title Text Color
    public var navBarViewToolViewBackgroundColor = UIColor(rgb: 0x272A31)
    
    /// 展示图片的背景颜色
    public var collectionViewBackViewBackgroundColor = UIColor.black
    
    /// 选中 时候 是否显示 Index 选中的 Index
    public var pickerSelectIndexMode = true
    /// 默认的图片 推荐大小 27*27
    public var pickerDefaultImage = SBImageMake("photo_def_photoPickerVc")
    /// 选中的图片 推荐大小 27*27 pickerSelectIndexMode 为true 则 不展示该 UIImage
    public var pickerSelectedImage = SBImageMake("photo_sel_photoPickerVc")
    
    /// 空白视图的 展位 属性
    public var emptyTitleAttributeString = "暂无更多图片".withTextColor(UIColor.white.a4).withFont(UIFont.f15.bold)
    public var emptySubTitleAttributeString = "你可以拍照，或者通过其他方式增加图片".withTextColor(UIColor.white.a4).withFont(UIFont.f13)
    
    /// 两个分页视图之间的距离
    public var pageViewControllerOptionInterPageSpace = 10.f
    
    /// 默认的 lightContent
    public var statusStyle:UIStatusBarStyle = .lightContent
    
    /// 是否在首页 UICollectionView 页面增加 Gif 支持
    public var showGifInCollectionMainView = false
    
    /// IOS11 -> 全面屏 会默认的上下留空，设置该属性为true则可以不留空
    public var previewViewControllerTopBottomSpaceZero = false
}
