//
//  SearchEndpoint.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/03.
//

import Foundation

enum UnsplashEndpoint {
    case search(query: String, page: Int = 1)
    case getPopular(page: Int = 1)
}

extension UnsplashEndpoint: EndpointType {
    
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
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
            return (nil, ["query": query, "page": page])
            
        case let .getPopular(page):
            return (nil, ["order_by": "popular", "page": page])
        }
    }
    
    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
        ]
    }
    
}
