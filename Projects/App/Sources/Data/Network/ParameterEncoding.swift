//
//  ParameterEncoding.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, parameters: Parameters) throws -> URLRequest
}

struct URLEncoding: ParameterEncoding {
    static var `default`: URLEncoding { URLEncoding() }
    
    func encode(_ urlRequest: URLRequest, parameters: Parameters) throws -> URLRequest {
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

struct JSONEncoding: ParameterEncoding {
    static var `default`: JSONEncoding { JSONEncoding() }
    
    func encode(_ urlRequest: URLRequest, parameters: Parameters) throws -> URLRequest {
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
