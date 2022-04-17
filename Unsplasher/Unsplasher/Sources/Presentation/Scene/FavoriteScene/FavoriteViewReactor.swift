//
//  FavoriteViewReactor.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/04.
//

import Foundation

import RxSwift
import ReactorKit

final class FavoriteViewReactor: Reactor {
    
    enum Action {
        case subscribeFavorites
    }
    
    enum Mutation {
        case setImages(with: [USImage])
    }
    
    struct State {
        @Pulse var usImages: [USImage]
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let favoriteImageUseCase: FavoriteImageUseCase
    
    init(
        favoriteImageUseCase: FavoriteImageUseCase
    ) {
        self.initialState = State(
            usImages: []
        )
        self.favoriteImageUseCase = favoriteImageUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .subscribeFavorites:
            return favoriteImageUseCase.subscribeFavorites()
                .map { Mutation.setImages(with: $0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setImages(usImages):
            newState.usImages = usImages
        }
        
        return newState
    }
    
    func makeDetailViewReactor(for selectedIndexPath: IndexPath) -> DetailViewReactor {
        let selectedItem = currentState.usImages[selectedIndexPath.item]
        let storageManager = StorageManager()
        let favoriteImageRepository = DefaultFavoriteImageRepository(storageManager: storageManager)
        let favoriteImageUseCase = DefaultFavoriteImageUseCase(favoriteImageRepository: favoriteImageRepository)
        return DetailViewReactor(favoriteImageUseCase: favoriteImageUseCase, usImage: selectedItem)
    }
}
