//
//  SearchImageUseCase.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

public protocol SearchImageUseCase {
    func searchImage(
        query: String,
        page: Int
    ) -> Observable<[USImage]>
}

public final class DefaultSearchImageUseCase: SearchImageUseCase {
    
    private let searchImageRepository: SearchImageRepository
    
    public init(
        searchImageRepository: SearchImageRepository
    ) {
        self.searchImageRepository = searchImageRepository
    }
    
    public func searchImage(
        query: String,
        page: Int
    ) -> Observable<[USImage]> {
        return searchImageRepository
            .searchImage(query: query, page: page)
    }
    
}
