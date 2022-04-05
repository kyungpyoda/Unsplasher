//
//  UnsplashAPIService.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import Foundation

protocol UnsplashAPIServiceType {
    func searchImage(query: String,
                     page: Int,
                     completion: @escaping (Result<[ImageModel], Error>) -> ()) -> Void
    func getPopulars(page: Int,
                     completion: @escaping (Result<[ImageModel], Error>) -> ()) -> Void
    func subscribeFavorites(block: @escaping ([ImageModel]) -> Void) -> Void
    func toggleFavorite(of imageModel: ImageModel) -> (ImageModel, Bool)
    func checkImageIsFavorite(_ imageModel: ImageModel) -> Bool
}

final class UnsplashAPIService: UnsplashAPIServiceType {
    
    private let networkManager: NetworkManagerType
    private let storageManager: StorageManagerType
    
    private let apiKey: String
    
    init(
        apiKey: String,
        networkManager: NetworkManagerType = NetworkManager(),
        storageManager: StorageManagerType = StorageManager()
    ) {
        self.apiKey = apiKey
        self.networkManager = networkManager
        self.storageManager = storageManager
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
    
    func subscribeFavorites(block: @escaping ([ImageModel]) -> Void) {
        storageManager.subscribe(for: ImageModel.self, block: block)
    }
    
    func toggleFavorite(of imageModel: ImageModel) -> (ImageModel, Bool) {
        if let stored = storageManager.read(type: ImageModel.self, key: imageModel.id) {
            let temp = ImageModel(value: imageModel)
            if storageManager.delete(stored) {
                return (temp, false)
            } else {
                return (imageModel, true)
            }
        } else {
            if storageManager.create(imageModel) {
                return (imageModel, true)
            } else {
                return (imageModel, false)
            }
        }
    }
    
    func checkImageIsFavorite(_ imageModel: ImageModel) -> Bool {
        return storageManager.read(type: ImageModel.self, key: imageModel.id) != nil
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
