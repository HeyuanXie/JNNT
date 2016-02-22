//
//  MineCollectionViewCell.swift
//  ZhiMaDi
//
//  Created by haijie on 16/2/22.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

import UIKit

class MineCollectionViewCell: UICollectionViewCell {
    var button : UIButton!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //初始化各种控件
        button = UIButton(frame: frame)
        button.backgroundColor = UIColor.whiteColor()
        self.addSubview(button)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
