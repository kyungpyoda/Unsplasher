//
//  DefaultFetchPopularImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import DomainModule
import NetworkModule
import ThirdPartyManager

import RxSwift

public final class DefaultFetchPopularImageRepository: FetchPopularImageRepository, NetworkingRepository {
    
    let networkManager: NetworkManagerType
    
    public init(
        networkManager: NetworkManagerType
    ) {
        self.networkManager = networkManager
    }
    
    public func getPopulars(page: Int) -> Observable<[USImage]> {
        let endpoint = UnsplashEndpoint.getPopular(page: page)
        return fetchRemote(from: endpoint)
            .map { (response: [ImageModel]) -> [USImage] in
                return response.map { $0.toDomain() }
            }
    }
    
}
