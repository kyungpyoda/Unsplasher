//
//  MockNetworkManager.swift
//  UnsplasherTests
//
//  Created by 홍경표 on 2021/08/14.
//

import Foundation
@testable import Unsplasher

final class MockNetworkManager: NetworkManagerType {
    
    let dummy: [Int: [ImageModel]] = [
        1: [
            .init().then {
                $0.desc = "no1"
            },
            .init().then {
                $0.desc = "no2"
            },
            .init().then {
                $0.desc = "no3"
            },
        ],
        2: [
            .init().then {
                $0.desc = "no1"
            },
            .init().then {
                $0.desc = "no2"
            },
            .init().then {
                $0.desc = "no3"
            },
        ],
        3: [
            .init().then {
                $0.desc = "no1"
            },
            .init().then {
                $0.desc = "no2"
            },
            .init().then {
                $0.desc = "no3"
            },
        ]
        
    ]
    
    func fetchData<T>(
        urlRequest: URLRequest,
        completion: @escaping (Result<T?, Error>) -> ()
    ) {
        let paths = urlRequest.url!.pathComponents
        let urlComponents = URLComponents(string: urlRequest.url!.absoluteString)
        var queryDict: [String: String] = [:]
        urlComponents!.queryItems!.forEach {
            queryDict[$0.name] = $0.value ?? ""
        }
        switch paths[1] {
        case "search": // search
            let result = (dummy[Int(queryDict["page"]!)!] ?? []).filter {
                $0.desc?.contains(queryDict["query"]!) ?? false
            }
            completion(.success(ImageSearchModel(total: result.count, totalPages: 3, results: result) as? T))
            
        case "photos": // popular
            let result = dummy[Int(queryDict["page"]!)!] ?? []
            completion(.success(result as? T))
            
        default:
            break
        }
    }
    
}
