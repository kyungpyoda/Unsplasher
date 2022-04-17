//
//  NetworkConfigurable.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters { get }
}

struct APINetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    let parameters: [String: Any]
    
    init(
        baseURL: URL,
        headers: HTTPHeaders = [:],
        parameters: Parameters = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.parameters = parameters
    }
}

