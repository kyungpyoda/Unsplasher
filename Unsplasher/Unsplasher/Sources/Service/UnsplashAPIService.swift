//
//  UnsplashAPIService.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import Foundation

protocol UnsplashAPIServiceType {
    var provider: ServiceProviderType { get }
    func searchImage(query: String,
                     page: Int,
                     completion: @escaping (Result<[ImageModel], Error>) -> ()) -> Void
    func getPopulars(page: Int,
                     completion: @escaping (Result<[ImageModel], Error>) -> ()) -> Void
}

final class UnsplashAPIService: UnsplashAPIServiceType {
    
    unowned let provider: ServiceProviderType
    
    private let networkManager: NetworkManager = .init()
    private let apiKey: String
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        apiKey = provider.globalPropertyService.apiKey
    }
    
    func searchImage(query: String,
                     page: Int = 1,
                     completion: @escaping (Result<[ImageModel], Error>) -> ()) {
        let request = searchRequest(for: query, page: page)
        
        networkManager.fetchData(urlRequest: request) { (result: Result<ImageSearchModel?, Error>) in
            switch result {
            case .success(let responseData):
                completion(.success(responseData?.results ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPopulars(page: Int = 1,
                      completion: @escaping (Result<[ImageModel], Error>) -> ()) {
        let request = getPopularsRequest(page: page)
        
        networkManager.fetchData(urlRequest: request) { (result: Result<[ImageModel]?, Error>) in
            switch result {
            case .success(let responseData):
                completion(.success(responseData ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func searchRequest(for query: String, page: Int) -> URLRequest {
        let endpoint = UnsplashEndpoint.search(query: query, page: page)
        var request = endpoint.urlRequest
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getPopularsRequest(page: Int) -> URLRequest {
        let endpoint = UnsplashEndpoint.getPopular(page: page)
        var request = endpoint.urlRequest
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
