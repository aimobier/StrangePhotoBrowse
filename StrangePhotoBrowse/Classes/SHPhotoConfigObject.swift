//
//  SHPhotoConfigObject.swift
//  Pods-StrangePhotoBrowse_Example
//
//  Created by 荆文征 on 2018/5/5.
//

import Foundation

public class SHPhotoConfigObject {
    
    /// 每一行展示的照片数目
    public var perLineDisplayNumber = 4
    
    /// 上下方的 NavBar ToolBar Back Color
    public var navBarViewToolViewBackColor = UIColor(red: 39.f/255, green: 42.f/255, blue: 49.f/255, alpha: 1)
    
    /// 展示图片的背景颜色
    public var collectionViewBackView = UIColor.black
    
    /// 空白视图的 展位 属性
    public var emptyTitleAttributeString = "暂无更多图片".withTextColor(UIColor.white.withAlphaComponent(0.4)).withFont(UIFont.boldSystemFont(ofSize: 15))
    public var emptySubTitleAttributeString = "你可以拍照，或者通过其他方式增加图片".withTextColor(UIColor.white.withAlphaComponent(0.4)).withFont(UIFont.systemFont(ofSize: 13))
}
