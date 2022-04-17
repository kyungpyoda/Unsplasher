//
//  NetworkConfigurable.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters { get }
}

public struct APINetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    public let headers: [String: String]
    public let parameters: [String: Any]
    
    public init(
        baseURL: URL,
        headers: HTTPHeaders = [:],
        parameters: Parameters = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.parameters = parameters
    }
}

