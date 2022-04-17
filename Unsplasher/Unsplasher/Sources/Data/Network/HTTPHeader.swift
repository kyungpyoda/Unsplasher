//
//  HTTPHeader.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HTTPHeaderValue: String {
    case jsonContent = "application/json"
    case urlContent = "application/x-www-form-urlencoded; charset=utf-8"
}

extension URLRequest {
    mutating func setValue(_ value: HTTPHeaderValue, forHTTPHeaderField field: HTTPHeaderKey) {
        setValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    func value(forHTTPHeaderField field: HTTPHeaderKey) -> String? {
        return value(forHTTPHeaderField: field.rawValue)
    }
}
