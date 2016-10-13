//
//  PCDropdownMenuView.swift
//  DropdownMenuDemo
//
//  Created by Artpower on 15/11/12.
//  Copyright © 2015年 http://www.devpc.cn. All rights reserved.
//

import UIKit

private let DROPDOWN_MENU_ANIMATE_DURATION: TimeInterval = 0.5


// MARK: -

public protocol PCDropdownMenuViewDataSource: NSObjectProtocol {
    
    // 菜单项总个数
    func numberOfRowInDropdownMenuView(_ view: PCDropdownMenuView) -> Int
    // 根据索引返回对应的菜单项
    func dropdownMenuView(_ view: PCDropdownMenuView, itemForRowAtIndexPath indexPath: IndexPath) -> PCDropdownMenuItem
    // 下拉菜单的箭头图标
    func dropdownMenuViewArrowImage(_ view: PCDropdownMenuView) -> UIImage?
    // 下拉菜单内容区域的frame,高度自适应
    func dropdownMenuViewContentFrame(_ view: PCDropdownMenuView) -> CGRect
    // 箭头图标的水平偏移值,调节箭头靠左还是靠右(忽略垂直偏移)
    func dropdownMenuViewArrowImageOffset(_ view: PCDropdownMenuView) -> UIOffset
    
}


// MARK: -

@objc public protocol PCDropdownMenuViewDelegate: NSObjectProtocol {
    // 菜单项被点击后的回调
    @objc optional func dropdownMenuViewDidSelectedItem(_ view: PCDropdownMenuView, inIndex index: Int)
}


// MARK: -

open class PCDropdownMenuView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    weak open var dataSource: PCDropdownMenuViewDataSource?
    weak open var delegate: PCDropdownMenuViewDelegate?
    
    fileprivate var contentView = UIView()
    fileprivate var arrowImageView = UIImageView()
    fileprivate var tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    // MARK: - Override Property
    
    override open var frame: CGRect {
        set {
            super.frame = UIScreen.main.bounds
        }
        get {
            return super.frame
        }
    }
    
    override open var bounds: CGRect {
        set {
            super.bounds = UIScreen.main.bounds
        }
        get {
            return super.bounds
        }
    }
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PCDropdownMenuView.tapGestureAction(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        
        self.addSubview(contentView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44.0
        tableView.layer.cornerRadius = 5.0
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let dataSource = self.dataSource {
            let image = dataSource.dropdownMenuViewArrowImage(self)
            let offset = dataSource.dropdownMenuViewArrowImageOffset(self)
            let imageSize = image?.size ?? CGSize.zero
            arrowImageView.image = image
            arrowImageView.frame = CGRect(x: offset.horizontal, y: 0.0, width: imageSize.width, height: imageSize.height)
            
            let count = dataSource.numberOfRowInDropdownMenuView(self)
            let tableHeight = CGFloat(count) * tableView.rowHeight
            var frame = dataSource.dropdownMenuViewContentFrame(self)
            frame.size.height = imageSize.height + tableHeight
            contentView.frame = frame
            
            tableView.frame = CGRect(x: 0.0, y: imageSize.height, width: frame.size.width, height: tableHeight)
        }
    }
    
    
    // MARK: - Public
    
    open func showWithAnimate(_ animate: Bool) {
        UIApplication.shared.keyWindow?.addSubview(self)
        if !animate {
            contentView.alpha = 1.0
            return
        }
        contentView.alpha = 0.0
        UIView.animate(withDuration: DROPDOWN_MENU_ANIMATE_DURATION) { () -> Void in
            self.contentView.alpha = 1.0
        }
    }
    
    open func hiddenWithAnimate(_ animate: Bool) {
        if !animate {
            self.removeFromSuperview()
            return
        }
        UIView.animate(withDuration: DROPDOWN_MENU_ANIMATE_DURATION, animations: { () -> Void in
            self.contentView.alpha = 0.0
            }) { (_) -> Void in
                self.removeFromSuperview()
        }
    }
    
    open func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        self.hiddenWithAnimate(true)
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.numberOfRowInDropdownMenuView(self)
        }
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        if let dataSource = self.dataSource {
            let item = dataSource.dropdownMenuView(self, itemForRowAtIndexPath: indexPath)
            cell?.textLabel?.text = item.name
            if let icon = item.icon , icon.isEmpty == false {
                cell?.imageView?.image = UIImage(named: icon)
            }
        }
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.delegate?.dropdownMenuViewDidSelectedItem?(self, inIndex: (indexPath as NSIndexPath).row)
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self)
    }

}
