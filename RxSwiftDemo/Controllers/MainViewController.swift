//
//  MainViewController.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Moya
import RxMoya
import SwiftyJSON
import ObjectMapper
import Kingfisher

class MainViewController: UIViewController {
    private var collectionView: WaterfallCollectionView?
    private let disposeBag = DisposeBag()
    private var gifs = Variable<[GIFModel]>([])
    private var gifsH: [CGFloat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        getTrendingData()
    }

    // Mark: - setup UI

    private func setupCollectionView() {
        // TODO: 1. refresh control 2. preload
        if #available(iOS 11.0, *) {
            collectionView = WaterfallCollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, itemHeightClosure: { (itemW, indexPath) -> CGFloat in
                if let height = self.gifs.value[indexPath.item].images?.fixed_width_downsampled_height {
                    if let doubleValue = Double(height) {
                        self.gifsH.append(CGFloat(doubleValue))
                        return CGFloat(doubleValue)
                    }
                }
                self.gifsH.append(0)
                return 0
            })
        } else {
            collectionView = WaterfallCollectionView(frame: view.frame, itemHeightClosure: { (itemW, indexPath) -> CGFloat in
                if let height = self.gifs.value[indexPath.item].images?.fixed_width_downsampled_height {
                    if let doubleValue = Double(height) {
                        self.gifsH.append(CGFloat(doubleValue))
                        return CGFloat(doubleValue)
                    }
                }
                self.gifsH.append(0)
                return 0
            })
        }
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = nil
        collectionView?.dataSource = nil
        view.addSubview(collectionView!)
    }

    private func setupDataSource() {
        guard let collectionView = collectionView else {
            return
        }
        gifs.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: WaterfallImgageCell.self)) { index, model, cell in
            if model.images?.fixed_width_downsampled_url != nil {
                if let url = URL(string: (model.images?.fixed_width_downsampled_url)!) {
                    cell.imageView.kf.setImage(with: url)
                }
            }
            cell.frame.size.height = self.gifsH[index]
            cell.imageView.frame.size.height = self.gifsH[index]
            }
            .disposed(by: disposeBag)
    }

    // Mark: - Data request3

    // TODO: 1. 网络状况变化 2. 内存泄露
    private func getTrendingData() {
        let provider = MoyaProvider<GIPHY>()
        provider.rx.request(.trending(api_key: API_KEY))
            .debug()
            .subscribe(onSuccess: { (response: Response) in
                let data = response.data
                let statusCode = response.statusCode
                do {
                    let json = try JSON(data:data)
                    if (statusCode >= 200 && statusCode < 300) {
                        var gifs: [GIFModel] = []
                        for (_,subJson):(String, JSON) in json["data"] {
                            if let jsonString = subJson.rawString() {
                                if let gif = GIFModel(JSONString: jsonString) {
                                    gifs.append(gif)
                                }
                            }
                        }
                        self.gifs.value = gifs
                    } else {
                        print(json["message"].stringValue)
                    }
                } catch {
                    print("json解析失败")
                }
            }) { (error) in
                print(error)
        }
            .disposed(by: disposeBag)
    }

}
