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
        backgroundColor = UIColor.white
        imageView.frame = frame
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}