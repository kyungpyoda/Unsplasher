//
//  URLSessionType.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

protocol URLSessionType {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionType { }
