//
//  WaterfallCollectionView.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit

class WaterfallCollectionView: UICollectionView {

    init(frame: CGRect, itemHeightClosure: ItemHeightClosure?) {
        let layout = WaterfallLayout(columnCount: 2, columnSpacing: 5, rowSpacing: 5, sectionInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), itemHeightClosure: itemHeightClosure)
        super.init(frame: frame, collectionViewLayout: layout)

        backgroundColor = UIColor.white
        register(WaterfallImgageCell.self, forCellWithReuseIdentifier: "cell")
    }

    override convenience init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
