//
//  FavoriteImageUseCase.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

public protocol FavoriteImageUseCase {
    func subscribeFavorites() -> Observable<[USImage]>
    func toggleFavorite(of usImage: USImage) -> Completable
    func checkImageIsFavorite(_ usImage: USImage) -> Bool
}

public final class DefaultFavoriteImageUseCase: FavoriteImageUseCase {
    
    private let favoriteImageRepository: FavoriteImageRepository
    
    public init(
        favoriteImageRepository: FavoriteImageRepository
    ) {
        self.favoriteImageRepository = favoriteImageRepository
    }
    
    public func subscribeFavorites() -> Observable<[USImage]> {
        return favoriteImageRepository.subscribeFavorites()
    }
    
    public func toggleFavorite(of usImage: USImage) -> Completable {
        return favoriteImageRepository.toggleFavorite(of: usImage)
    }
    
    public func checkImageIsFavorite(_ usImage: USImage) -> Bool {
        return favoriteImageRepository.checkImageIsFavorite(usImage)
    }
    
}
