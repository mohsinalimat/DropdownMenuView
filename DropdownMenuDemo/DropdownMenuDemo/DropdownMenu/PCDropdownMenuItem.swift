//
//  PCDropdownMenuItem.swift
//  DropdownMenuDemo
//
//  Created by Artpower on 15/11/12.
//  Copyright © 2015年 http://www.devpc.cn. All rights reserved.
//

import UIKit

open class PCDropdownMenuItem: NSObject {

    open var name: String
    open var icon: String?
    
    init(name: String, icon: String?) {
        self.name = name
        self.icon = icon
    }

}
