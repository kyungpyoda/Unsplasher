//
//  EndpointType.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/03.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    
    typealias Parameters = [String: Any]
    typealias HTTPTask = (body: Data?, queryItems: Parameters?)
    typealias HTTPHeaders = [String: String]
}

extension EndpointType {
    var urlRequest: URLRequest {
        var url = baseURL.appendingPathComponent(path)
        Self.parameterEncode(url: &url, queries: httpTask.queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpTask.body
        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    static func parameterEncode(url: inout URL, queries: Parameters?) {
        guard var urlComponents = URLComponents(string: url.absoluteString),
              let queries = queries else {
            return
        }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        for (key, value) in queries {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents.queryItems = queryItems
        
        url = urlComponents.url ?? url.absoluteURL
    }
}
