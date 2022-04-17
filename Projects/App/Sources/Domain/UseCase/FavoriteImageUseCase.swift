//
//  FavoriteImageUseCase.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

protocol FavoriteImageUseCase {
    func subscribeFavorites() -> Observable<[USImage]>
    func toggleFavorite(of usImage: USImage) -> Completable
    func checkImageIsFavorite(_ usImage: USImage) -> Bool
}

final class DefaultFavoriteImageUseCase: FavoriteImageUseCase {
    
    private let favoriteImageRepository: FavoriteImageRepository
    
    init(
        favoriteImageRepository: FavoriteImageRepository
    ) {
        self.favoriteImageRepository = favoriteImageRepository
    }
    
    func subscribeFavorites() -> Observable<[USImage]> {
        return favoriteImageRepository.subscribeFavorites()
    }
    
    func toggleFavorite(of usImage: USImage) -> Completable {
        return favoriteImageRepository.toggleFavorite(of: usImage)
    }
    
    func checkImageIsFavorite(_ usImage: USImage) -> Bool {
        return favoriteImageRepository.checkImageIsFavorite(usImage)
    }
    
}
