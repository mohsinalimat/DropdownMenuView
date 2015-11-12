//
//  ViewController.swift
//  DropdownMenuDemo
//
//  Created by Artpower on 15/11/12.
//  Copyright © 2015年 http://www.devpc.cn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PCDropdownMenuViewDataSource, PCDropdownMenuViewDelegate {
    
    let dropdownMenuView = PCDropdownMenuView()
    let menuWidth: CGFloat = 155.0
    var items: [PCDropdownMenuItem] = []
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("showDropdownMenu"))
        self.navigationItem.rightBarButtonItem = barButton
        
        dropdownMenuView.dataSource = self
        dropdownMenuView.delegate = self
        
        items = [PCDropdownMenuItem(name: "扫一扫", icon: "shortcut_QR@3x.png"),
                PCDropdownMenuItem(name: "加好友", icon: "shortcut_addFri@3x.png"),
                PCDropdownMenuItem(name: "发送到电脑", icon: "shortcut_sendFile@3x.png"),
                PCDropdownMenuItem(name: "收钱", icon: "shortcut_payMoney@3x.png")]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropdownMenuView.frame = CGRectZero
    }

    func showDropdownMenu() {
        dropdownMenuView.showWithAnimate(true)
    }
    
    // MARK: - PCDropdownMenuViewDataSource
    
    func numberOfRowInDropdownMenuView(view: PCDropdownMenuView) -> Int {
        return items.count
    }
    
    func dropdownMenuView(view: PCDropdownMenuView, itemForRowAtIndexPath indexPath: NSIndexPath) -> PCDropdownMenuItem {
        return items[indexPath.row]
    }
    
    func dropdownMenuViewArrowImageOffset(view: PCDropdownMenuView) -> UIOffset {
        return UIOffset(horizontal: menuWidth - 25.0, vertical: 0.0)
    }
    
    func dropdownMenuViewContentFrame(view: PCDropdownMenuView) -> CGRect {
        let isPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation)
        let x: CGFloat = UIScreen.mainScreen().bounds.size.width - menuWidth - 5.0
        let y: CGFloat = isPortrait ? 64.0 : (self.navigationController?.navigationBar.frame.size.height ?? 44.0)
        return CGRectMake(x, y, menuWidth, 0.0)
    }
    
    func dropdownMenuViewArrowImage(view: PCDropdownMenuView) -> UIImage? {
        return UIImage(named: "mqz_qun_header_arrow_icon@2x.png")
    }
    
    // MARK: - PCDropdownMenuViewDelegate
    
    func dropdownMenuViewDidSelectedItem(view: PCDropdownMenuView, inIndex index: Int) {
        view.hiddenWithAnimate(true)
        
        let item = items[index]
        print(item.name)
    }
}

