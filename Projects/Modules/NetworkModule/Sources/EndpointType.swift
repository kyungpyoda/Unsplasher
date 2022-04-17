//
//  EndpointType.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/03.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask {
    case request
    
    case requestParameters(
        encoding: ParameterEncoding,
        parameters: Parameters
    )
    
    case requestEncodable(
        encoding: ParameterEncoding,
        encodable: Encodable
    )
    
    case requestJSONEncodable(Encodable)
}

public protocol EndpointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndpointType {
    
    /// Endpoint와 NetworkConfigurable 정보를 합쳐서 URLRequest 생성
    func buildRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = config.baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        // 파라미터 인코딩
        do {
            switch httpTask {
            case .request:
                request.setValue(.jsonContent, forHTTPHeaderField: .contentType)
                
            case let .requestParameters(encoding, parameters):
                request = try encoding.encode(request, parameters: parameters)
                
            case let .requestEncodable(encoding, encodable):
                let encodable = AnyEncodable(encodable)
                let parameters = try encodable.asDictionary()
                request = try encoding.encode(request, parameters: parameters)
                
            case let .requestJSONEncodable(encodable):
                let encodable = AnyEncodable(encodable)
                request.httpBody = try JSONEncoder().encode(encodable)
                if request.value(forHTTPHeaderField: .contentType) == nil {
                    request.setValue(.jsonContent, forHTTPHeaderField: .contentType)
                }
            }
        } catch(let catchedError) {
            throw NetworkManagerError.InvalidRequest(catchedError)
        }
        
        // 헤더
        let allHeaders = headers?.merging(config.headers) { _, config in return config }
        allHeaders?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
}
