//
//  FavoriteImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation
import RxSwift

public protocol FavoriteImageRepository {
    func subscribeFavorites() -> Observable<[USImage]>
    func toggleFavorite(of usImage: USImage) -> Completable
    func checkImageIsFavorite(_ usImage: USImage) -> Bool
}
