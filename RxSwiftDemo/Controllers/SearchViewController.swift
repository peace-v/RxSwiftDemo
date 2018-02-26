//
//  SearchViewController.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Moya
import RxMoya
import SwiftyJSON
import ObjectMapper
import Kingfisher

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    private var collectionView: WaterfallCollectionView?
    private let disposeBag = DisposeBag()

    private var gifs = Variable<[GIFModel]>([])
    private var gifsH: [CGFloat] = []
    private var offset: Int32 = 0

//    private var searchString: Observable<String> {
//        return searchBar
//            .rx.text
//            .orEmpty
//            .throttle(0.3, scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//    }
    private var searchAction: Observable<Void> {
        return searchBar.rx.searchButtonClicked.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        setupSearchAction()
        configDismissKeyboardOnScroll()
    }

    deinit {
        print("搜索页面被释放了")
    }

    // Mark: - setup UI

    private func setupCollectionView() {
        // TODO: refresh control
        let searchBarH = searchBar.frame.size.height
        let navY = navigationController?.navigationBar.frame.maxY ?? 64
        let collectionViewFrame = CGRect(x: 0, y: searchBarH + navY, width: view.frame.width, height: view.frame.height - searchBarH - navY)

        collectionView = WaterfallCollectionView(frame: collectionViewFrame, itemHeightClosure: { (itemW, indexPath) -> CGFloat in
            if let height = self.gifs.value[indexPath.item].images?.fixed_width_downsampled_height {
                if let doubleValue = Double(height) {
                    self.gifsH.append(CGFloat(doubleValue))
                    return CGFloat(doubleValue)
                }
            }
            self.gifsH.append(0)
            return 0
        })
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

    private func setupSearchAction() {
//        searchString
//        .debug()
//        .observeOn(MainScheduler.instance)
//        .flatMapLatest{ query -> Observable<[GIFModel]> in
//                self.getSearchData(query)
//        }
//        .subscribe()
//        .disposed(by: disposeBag)

        // TODO: 如何结合searchButtonClicked && rx.text的结果
        searchAction
        .debug()
        .flatMapLatest{ _ -> Observable<[GIFModel]> in
            if self.searchBar.text != nil && !self.searchBar.text!.isEmpty {
                return self.getSearchData(self.searchBar.text!)
            } else {
                return Observable.empty()
            }
        }
        .subscribe()
        .disposed(by: disposeBag)

    }

    private func configDismissKeyboardOnScroll() {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if self.searchBar.isFirstResponder {
                    self.searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }

    // Mark: - Data request

    // TODO: 1. 网络状况变化 2. 内存泄露 3. 出错重试
    private func getSearchData(_ query:String) -> Observable<[GIFModel]> {
        let provider = MoyaProvider<GIPHY>()
        var gifs: [GIFModel] = []
        provider.rx.request(.search(api_key: API_KEY, q: query, offset: offset))
            .debug()
            .subscribe(onSuccess: { (response: Response) in
                let data = response.data
                let statusCode = response.statusCode
                do {
                    let json = try JSON(data:data)
                    if (statusCode >= 200 && statusCode < 300) {
                        for (_,subJson):(String, JSON) in json["data"] {
                            if let jsonString = subJson.rawString() {
                                if let gif = GIFModel(JSONString: jsonString) {
                                    gifs.append(gif)
                                }
                            }
                        }
                        self.gifsH = []
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
        return Observable.of(gifs)
    }
}
