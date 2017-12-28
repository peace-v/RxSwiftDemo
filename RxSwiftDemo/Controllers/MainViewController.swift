//
//  MainViewController.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: WaterfallCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    // Mark: - setup UI

    private func setupCollectionView() {
        if #available(iOS 11.0, *) {
            collectionView = WaterfallCollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, itemHeightClosure: { (itemW, indexPath) -> CGFloat in
                let random = arc4random() % 2
                if random == 0 {
                    return 100
                }
                return 200
            })
        } else {
            collectionView = WaterfallCollectionView(frame: view.frame, itemHeightClosure: { (itemW, indexPath) -> CGFloat in
                let random = arc4random() % 2
                if random == 0 {
                    return 100
                }
                return 200
            })
        }
        collectionView?.backgroundColor = UIColor.yellow
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
    }

    // Mark: - UICollectionViewDelegate && UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.cyan
        return cell
    }

}
