//
//  SearchEndpoint.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/03.
//

import Foundation

import NetworkModule

enum UnsplashEndpoint {
    case search(query: String, page: Int = 1)
    case getPopular(page: Int = 1)
}

extension UnsplashEndpoint: EndpointType {
    var path: String {
        switch self {
        case .search:
            return "search/photos"
        case .getPopular:
            return "photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search: return .get
        case .getPopular: return .get
        }
    }
    
    var httpTask: HTTPTask {
        switch self {
        case let .search(query, page):
            return .requestParameters(encoding: URLEncoding.default, parameters: ["query": query, "page": page])
            
        case let .getPopular(page):
            return .requestParameters(encoding: URLEncoding.default, parameters: ["order_by": "popular", "page": page])
        }
    }
    
    var headers: HTTPHeaders? {
        return [
            HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.jsonContent.rawValue
        ]
    }
}
