//
//  WaterfallLayout.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit

typealias ItemHeightClosure = (_ itemWidth: CGFloat, _ indexPath: IndexPath) -> CGFloat

class WaterfallLayout: UICollectionViewLayout {
    private var columnCount = 2
    private var columnSpacing: CGFloat = 0
    private var rowSpacing: CGFloat = 0
    private var sectionInsets = UIEdgeInsets.zero
    private var columnMaxYDic: [Int:CGFloat] = [:]
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var itemHeightClosure: ItemHeightClosure?

    override var collectionViewContentSize: CGSize {
        var longestColumn = 0
        for (key, value) in columnMaxYDic {
            if columnMaxYDic[longestColumn] != nil && value > columnMaxYDic[longestColumn]! {
                longestColumn = key
            }
        }
        if columnMaxYDic[longestColumn] != nil {
            return CGSize(width: 0, height: columnMaxYDic[longestColumn]! + sectionInsets.bottom)
        } else {
            return CGSize.zero
        }
    }

    init(columnCount: Int, columnSpacing: CGFloat, rowSpacing: CGFloat, sectionInsets: UIEdgeInsets, itemHeightClosure: ItemHeightClosure?) {
        super.init()
        self.columnCount = columnCount
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.sectionInsets = sectionInsets
        self.itemHeightClosure = itemHeightClosure
    }

    override convenience init() {
        self.init(columnCount: 0, columnSpacing: 0, rowSpacing: 0, sectionInsets: UIEdgeInsets.zero, itemHeightClosure: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO:什么时候会调用
    override func prepare() {
        super.prepare()

        // TODO:是否有必要写在这里
        if columnCount > 0 {
            for item in 0..<columnCount {
                columnMaxYDic[item] = sectionInsets.top
            }
        }

        attributes.removeAll()
        // TODO:多个section怎么办
        if let itemCount = collectionView?.numberOfItems(inSection: 0) {
            for item in 0..<itemCount {
                if let attribute = layoutAttributesForItem(at: IndexPath(item: item, section: 0)) {
                    attributes.append(attribute)
                }
            }
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        // TODO:先写死，之后考虑怎么传值
        // 宽度
        let collectionViewW = UIScreen.main.bounds.size.width
        let space = columnSpacing * CGFloat(columnCount - 1)
        let itemW = (collectionViewW - sectionInsets.left - sectionInsets.right - space) / CGFloat(columnCount)

        // 高度
        var itemH:CGFloat = 0
        if itemHeightClosure != nil {
            itemH = itemHeightClosure!(itemW, indexPath)
        }

        // 拿到最短column
        var shortestColumn = 0
        for (key, value) in columnMaxYDic {
            if columnMaxYDic[shortestColumn] != nil && value < columnMaxYDic[shortestColumn]! {
                shortestColumn = key
            }
        }

        // x, y
        let itemX = sectionInsets.left + (itemW + columnSpacing) * CGFloat(shortestColumn)
        var itemY: CGFloat = 0
        if columnMaxYDic[shortestColumn] != nil {
            itemY = columnMaxYDic[shortestColumn]! + rowSpacing
        }

        attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
        columnMaxYDic[shortestColumn] = attribute.frame.maxY
        return attribute
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }

}
