//
//  DefaultFavoriteImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

final class DefaultFavoriteImageRepository: FavoriteImageRepository, PersistingRepository {
    
    let storageManager: StorageManagerType
    
    init(
        storageManager: StorageManagerType
    ) {
        self.storageManager = storageManager
    }
    
    func subscribeFavorites() -> Observable<[USImage]> {
        let subject = PublishSubject<[USImage]>()
        storageManager.subscribe(for: ImageModel.self) { [weak subject] imageModels in
            subject?.onNext(imageModels.toDomain())
        }
        return subject.asObservable()
    }
    
    func toggleFavorite(of usImage: USImage) -> Completable {
        return Completable.create { [weak self] completable in
            if let stored = self?.storageManager.read(type: ImageModel.self, key: usImage.id) {
                do {
                    try self?.storageManager.delete(stored)
                    completable(.completed)
                } catch(let catchedError) {
                    completable(.error(catchedError))
                }
            } else {
                let imageModel = ImageModel(with: usImage)
                do {
                    try self?.storageManager.create(imageModel)
                    completable(.completed)
                } catch(let catchedError) {
                    completable(.error(catchedError))
                }
            }
            return Disposables.create()
        }
    }
    
    func checkImageIsFavorite(_ usImage: USImage) -> Bool {
        return storageManager.read(type: ImageModel.self, key: usImage.id) != nil
    }
    
}
