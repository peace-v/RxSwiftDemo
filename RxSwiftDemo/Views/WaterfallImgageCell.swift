//
//  WaterfallImgageCell.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit
import Kingfisher

class WaterfallImgageCell: UICollectionViewCell {
    var imageView = AnimatedImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imageView.backgroundColor = UIColor.yellow
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
