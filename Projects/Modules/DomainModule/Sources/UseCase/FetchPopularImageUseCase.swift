//
//  FetchPopularImageUseCase.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

public protocol FetchPopularImageUseCase {
    func getPopulars(page: Int) -> Observable<[USImage]>
}

public final class DefaultFetchPopularImageUseCase: FetchPopularImageUseCase {
    
    private let fetchPopularImageRepository: FetchPopularImageRepository
    
    public init(
        fetchPopularImageRepository: FetchPopularImageRepository
    ) {
        self.fetchPopularImageRepository = fetchPopularImageRepository
    }
    
    public func getPopulars(page: Int) -> Observable<[USImage]> {
        return fetchPopularImageRepository
            .getPopulars(page: page)
    }
}
