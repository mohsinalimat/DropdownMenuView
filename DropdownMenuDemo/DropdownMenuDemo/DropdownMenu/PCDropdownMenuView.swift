//
//  PCDropdownMenuView.swift
//  DropdownMenuDemo
//
//  Created by Artpower on 15/11/12.
//  Copyright © 2015年 http://www.devpc.cn. All rights reserved.
//

import UIKit

private let DROPDOWN_MENU_ANIMATE_DURATION: NSTimeInterval = 0.5


// MARK: -

public protocol PCDropdownMenuViewDataSource: NSObjectProtocol {
    
    // 菜单项总个数
    func numberOfRowInDropdownMenuView(view: PCDropdownMenuView) -> Int
    // 根据索引返回对应的菜单项
    func dropdownMenuView(view: PCDropdownMenuView, itemForRowAtIndexPath indexPath: NSIndexPath) -> PCDropdownMenuItem
    // 下拉菜单的箭头图标
    func dropdownMenuViewArrowImage(view: PCDropdownMenuView) -> UIImage?
    // 下拉菜单内容区域的frame,高度自适应
    func dropdownMenuViewContentFrame(view: PCDropdownMenuView) -> CGRect
    // 箭头图标的水平偏移值,调节箭头靠左还是靠右(忽略垂直偏移)
    func dropdownMenuViewArrowImageOffset(view: PCDropdownMenuView) -> UIOffset
    
}


// MARK: -

@objc public protocol PCDropdownMenuViewDelegate: NSObjectProtocol {
    // 菜单项被点击后的回调
    optional func dropdownMenuViewDidSelectedItem(view: PCDropdownMenuView, inIndex index: Int)
}


// MARK: -

public class PCDropdownMenuView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    weak public var dataSource: PCDropdownMenuViewDataSource?
    weak public var delegate: PCDropdownMenuViewDelegate?
    
    private var contentView = UIView()
    private var arrowImageView = UIImageView()
    private var tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    
    // MARK: - Override Property
    
    override public var frame: CGRect {
        set {
            super.frame = UIScreen.mainScreen().applicationFrame
        }
        get {
            return super.frame
        }
    }
    
    override public var bounds: CGRect {
        set {
            super.bounds = UIScreen.mainScreen().applicationFrame
        }
        get {
            return super.bounds
        }
    }
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapGestureAction:"))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(contentView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44.0
        tableView.layer.cornerRadius = 5.0
        tableView.layer.masksToBounds = true
        tableView.scrollEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let dataSource = self.dataSource {
            let image = dataSource.dropdownMenuViewArrowImage(self)
            let offset = dataSource.dropdownMenuViewArrowImageOffset(self)
            let imageSize = image?.size ?? CGSizeZero
            arrowImageView.image = image
            arrowImageView.frame = CGRectMake(offset.horizontal, 0.0, imageSize.width, imageSize.height)
            
            let count = dataSource.numberOfRowInDropdownMenuView(self)
            let tableHeight = CGFloat(count) * tableView.rowHeight
            var frame = dataSource.dropdownMenuViewContentFrame(self)
            frame.size.height = imageSize.height + tableHeight
            contentView.frame = frame
            
            tableView.frame = CGRectMake(0.0, imageSize.height, frame.size.width, tableHeight)
        }
    }
    
    
    // MARK: - Public
    
    public func showWithAnimate(animate: Bool) {
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        if !animate {
            contentView.alpha = 1.0
            return
        }
        contentView.alpha = 0.0
        UIView.animateWithDuration(DROPDOWN_MENU_ANIMATE_DURATION) { () -> Void in
            self.contentView.alpha = 1.0
        }
    }
    
    public func hiddenWithAnimate(animate: Bool) {
        if !animate {
            self.removeFromSuperview()
            return
        }
        UIView.animateWithDuration(DROPDOWN_MENU_ANIMATE_DURATION, animations: { () -> Void in
            self.contentView.alpha = 0.0
            }) { (_) -> Void in
                self.removeFromSuperview()
        }
    }
    
    public func tapGestureAction(recognizer: UITapGestureRecognizer) {
        self.hiddenWithAnimate(true)
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.numberOfRowInDropdownMenuView(self)
        }
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        if let dataSource = self.dataSource {
            let item = dataSource.dropdownMenuView(self, itemForRowAtIndexPath: indexPath)
            cell?.textLabel?.text = item.name
            if let icon = item.icon where icon.isEmpty == false {
                cell?.imageView?.image = UIImage(named: icon)
            }
        }
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.delegate?.dropdownMenuViewDidSelectedItem?(self, inIndex: indexPath.row)
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view == self)
    }

}
