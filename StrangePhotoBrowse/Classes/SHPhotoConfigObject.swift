//
//  SHPhotoConfigObject.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Foundation

public class SHPhotoConfigObject {
    
    /// 默认的
    public static let share = SHPhotoConfigObject()
    
    /// 主题色
    public var mainColor = UIColor(rgb: 0x3979e6)
    
    /// 每一行展示的照片数目
    public var perLineDisplayNumber = 4
    
    /// 上下方的 NavBar ToolBar Back Color
    public var navBarViewToolViewBackColor = UIColor(rgb: 0x272A31)
    
    /// 展示图片的背景颜色
    public var collectionViewBackView = UIColor.black
    
    /// 默认的图片 推荐大小 27*27
    public var pickerDefaultImage = SBImageMake("photo_def_photoPickerVc")
    /// 选中的图片 推荐大小 27*27
    public var pickerSelectedImage = SBImageMake("photo_sel_photoPickerVc")
    
    /// 空白视图的 展位 属性
    public var emptyTitleAttributeString = "暂无更多图片".withTextColor(UIColor.white.a4).withFont(UIFont.f15.bold)
    public var emptySubTitleAttributeString = "你可以拍照，或者通过其他方式增加图片".withTextColor(UIColor.white.a4).withFont(UIFont.f13)
}
