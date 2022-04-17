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
    
    init(
        networkManager: NetworkManagerType,
        storageManager: StorageManagerType
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    func searchImage(query: String,
                     page: Int = 1,
                     completion: @escaping (Result<[ImageModel], Error>) -> ()) {
        let endpoint = UnsplashEndpoint.search(query: query, page: page)
        _ = networkManager.fetchData(from: endpoint) { (result: Result<ImageSearchModel?, Error>) in
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
        let endpoint = UnsplashEndpoint.getPopular(page: page)
        _ = networkManager.fetchData(from: endpoint) { (result: Result<[ImageModel]?, Error>) in
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
    
}
