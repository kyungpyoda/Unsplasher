//
//  DetailViewReactor.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/04.
//

import Foundation

import RxSwift
import ReactorKit

final class DetailViewReactor: Reactor {
    
    enum Action {
        case toggleFavorite
    }
    
    enum Mutation {
        case setIsFavorite(to: Bool)
    }
    
    struct State {
        @Pulse var usImage: USImage
        @Pulse var isFavorite: Bool
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let favoriteImageUseCase: FavoriteImageUseCase
    
    init(
        favoriteImageUseCase: FavoriteImageUseCase,
        usImage: USImage
    ) {
        self.initialState = State(
            usImage: usImage,
            isFavorite: favoriteImageUseCase.checkImageIsFavorite(usImage)
        )
        self.favoriteImageUseCase = favoriteImageUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleFavorite:
            return favoriteImageUseCase.toggleFavorite(of: currentState.usImage)
                .andThen(.just(.setIsFavorite(to: !currentState.isFavorite))).debug()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setIsFavorite(isFavorite):
            newState.isFavorite = isFavorite
        }
        
        return newState
    }
}
