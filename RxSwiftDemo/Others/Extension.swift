//
//  Extension.swift
//  RxSwiftDemo
//
//  Created by yuying on 2018/1/15.
//  Copyright © 2018年 yuying. All rights reserved.
//

import UIKit

extension UIImage {
    class func createImage(color:UIColor, size:CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
