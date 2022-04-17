//
//  DefaultFetchPopularImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

final class DefaultFetchPopularImageRepository: FetchPopularImageRepository, NetworkingRepository {
    
    let networkManager: NetworkManagerType
    
    init(
        networkManager: NetworkManagerType
    ) {
        self.networkManager = networkManager
    }
    
    func getPopulars(page: Int) -> Observable<[USImage]> {
        let endpoint = UnsplashEndpoint.getPopular(page: page)
        return fetchRemote(from: endpoint)
            .map { (response: [ImageModel]) -> [USImage] in
                return response.map { $0.toDomain() }
            }
    }
    
}
