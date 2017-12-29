//
//  MainViewController.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import RxMoya

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionView: WaterfallCollectionView?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getTrendingData()
    }

    // Mark: - setup UI

    private func setupCollectionView() {
        // TODO: 1. refresh control 2. preload
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

    // Mark: - Data request

    // TODO:网络状况变化
    private func getTrendingData() {
        let provider = MoyaProvider<GIPHY>()
        provider.rx.request(.trending(api_key: API_KEY))
            .debug()
            .filterSuccessfulStatusCodes()
            .subscribe(onSuccess: { (response: Response) in
//                let data = response.data
//                do {
//                    let json = try JSON(data:data)
//                    print(json)
//                } catch {
//                }
        }) { (error) in
            print(error)
        }
            .disposed(by: disposeBag)
    }

}
