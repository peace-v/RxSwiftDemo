//
//  ImageViewController.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/27.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func save(_ sender: Any) {
    }

    var url:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
            let url = URL(string: self.url!)
            let screenW = UIScreen.main.bounds.size.width
            let placeholder = UIImage.createImage(color:UIColor.yellow, size:CGSize(width: screenW, height: screenW))
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, placeholder: placeholder)
            { (image, error, cacheType, imageUrl) in
                if image != nil {
                    let imageSize = image!.size
                    let navH = self.navigationController?.navigationBar.frame.size.height ?? 0
                    if imageSize.width > screenW {
                        let height = imageSize.height * screenW / imageSize.width
                        self.imageView.frame = CGRect(x: 0, y: navH, width: screenW, height: height)
                    } else {
                        self.imageView.frame = CGRect(x: (screenW - imageSize.width) / 2, y: navH, width: imageSize.width, height: imageSize.height)
                    }
                }
            }
        }
    }

    deinit {
        print("详情页面被释放了")
    }

}
