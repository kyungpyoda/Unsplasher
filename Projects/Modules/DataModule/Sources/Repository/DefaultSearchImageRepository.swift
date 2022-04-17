//
//  DefaultSearchImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import DomainModule
import NetworkModule
import ThirdPartyManager

import RxSwift

public final class DefaultSearchImageRepository: SearchImageRepository, NetworkingRepository {
    
    let networkManager: NetworkManagerType
    
    public init(
        networkManager: NetworkManagerType
    ) {
        self.networkManager = networkManager
    }
    
    public func searchImage(query: String, page: Int) -> Observable<[USImage]> {
        let endpoint = UnsplashEndpoint.search(query: query, page: page)
        return fetchRemote(from: endpoint)
            .map { (response: ImageSearchModel) -> [USImage] in
                return response.results
                    .map { $0.toDomain() }
            }
    }
    
}
