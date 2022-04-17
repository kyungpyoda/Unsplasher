//
//  FetchPopularImageUseCase.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

protocol FetchPopularImageUseCase {
    func getPopulars(page: Int) -> Observable<[USImage]>
}

final class DefaultFetchPopularImageUseCase: FetchPopularImageUseCase {
    
    private let fetchPopularImageRepository: FetchPopularImageRepository
    
    init(
        fetchPopularImageRepository: FetchPopularImageRepository
    ) {
        self.fetchPopularImageRepository = fetchPopularImageRepository
    }
    
    func getPopulars(page: Int) -> Observable<[USImage]> {
        return fetchPopularImageRepository
            .getPopulars(page: page)
    }
}
