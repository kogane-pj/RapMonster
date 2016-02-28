//
//  RMNavigationItem.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/28.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class RMNavigationItem: UINavigationItem {
   
    override init(title: String) {
        super.init(title: title)
        
        //TODO:TitleViewの中にtitle引き渡すようにのちのち回収
        let titleView = RMTitleView()
        titleView.titleLabel.text = title
        
        self.titleView = titleView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
