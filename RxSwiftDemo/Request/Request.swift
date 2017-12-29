//
//  Request.swift
//  RxSwiftDemo
//
//  Created by yuying on 2017/12/28.
//  Copyright © 2017年 yuying. All rights reserved.
//

import UIKit
import Moya

enum GIPHY {
    case trending(api_key: String)
    case search(api_key: String, q: String, offset: Int32)
    case getGIFByID(api_key: String, gif_id: String)
}

extension GIPHY: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.giphy.com")!
    }

    var path: String {
        switch self {
        case .trending(_):
            return "/v1/gifs/trending"
        case .search(_, _, _):
            return "/v1/gifs/search"
        case .getGIFByID(_, let gif_id):
            return "/v1/gifs/\(gif_id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        switch self {
        case .trending(let api_key):
            return ["api_key": api_key]
        case .search(let api_key, let q, let offset):
            return ["api_key": api_key, "q": q, "offset": offset]
        case .getGIFByID(let api_key, let gif_id):
            return ["api_key": api_key, "gif_id":gif_id]
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var task: Task {
//        return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        return .requestPlain
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var headers: [String : String]? {
        return nil
    }
}
