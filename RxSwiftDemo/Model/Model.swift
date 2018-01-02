//
//  Model.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/29.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit
import ObjectMapper

struct GIFModel: Mappable {
    var id = ""
    var url = ""
    var title = ""
    var images: ImageModel?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        title <- map["title"]
        images <- map["images"]
    }
}

struct ImageModel: Mappable {
    var fixed_width_downsampled_url = ""
    var fixed_width_downsampled_width = ""
    var fixed_width_downsampled_height = ""

    var downsized_url = ""
    var downsized_width = ""
    var downsized_height = ""

    var original_url = ""
    var original_width = ""
    var original_height = ""

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        fixed_width_downsampled_url <- map["fixed_width_downsampled.url"]
        fixed_width_downsampled_width <- map["fixed_width_downsampled.width"]
        fixed_width_downsampled_height <- map["fixed_width_downsampled.height"]

        downsized_url <- map["downsized.url"]
        downsized_width <- map["downsized.width"]
        downsized_height <- map["downsized.height"]

        original_url <- map["original.url"]
        original_width <- map["original.width"]
        original_height <- map["original.height"]
    }

}
