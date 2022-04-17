//
//  ParameterEncoding.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, parameters: Parameters) throws -> URLRequest
}

public struct URLEncoding: ParameterEncoding {
    public static var `default`: URLEncoding { URLEncoding() }
    
    public func encode(_ urlRequest: URLRequest, parameters: Parameters) throws -> URLRequest {
        var urlRequest = urlRequest
        do {
            guard let url = urlRequest.url,
                  var urlComponents = URLComponents(string: url.absoluteString) else {
                throw NetworkManagerError.InvalidRequest(nil)
            }
            
            urlComponents.percentEncodedQuery = parameters.map { key, value in
                (key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key)
                + "="
                + ("\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "\(value)")
            }.joined(separator: "&")
            
            urlRequest.url = urlComponents.url
            
            if urlRequest.value(forHTTPHeaderField: .contentType) == nil {
                urlRequest.setValue(.urlContent, forHTTPHeaderField: .contentType)
            }
            return urlRequest
        } catch(let catchedError) {
            throw NetworkManagerError.InvalidRequest(catchedError)
        }
    }
}

public struct JSONEncoding: ParameterEncoding {
    public static var `default`: JSONEncoding { JSONEncoding() }
    
    public func encode(_ urlRequest: URLRequest, parameters: Parameters) throws -> URLRequest {
        var urlRequest = urlRequest
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            if urlRequest.value(forHTTPHeaderField: .contentType) == nil {
                urlRequest.setValue(.jsonContent, forHTTPHeaderField: .contentType)
            }
            return urlRequest
        } catch(let catchedError) {
            throw NetworkManagerError.InvalidRequest(catchedError)
        }
    }
}
