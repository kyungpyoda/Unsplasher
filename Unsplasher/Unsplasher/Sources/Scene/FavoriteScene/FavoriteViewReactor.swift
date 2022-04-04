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
        case setImageModels(with: [ImageModel])
    }
    
    struct State {
        @Pulse var imageModels: [ImageModel]
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let serviceProvider: ServiceProviderType
    
    init(
        serviceProvider: ServiceProviderType
    ) {
        self.initialState = State(
            imageModels: []
        )
        self.serviceProvider = serviceProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .subscribeFavorites:
            return Observable<[ImageModel]>.create { [weak self] observer in
                if let self = self {
                    self.serviceProvider.unsplashAPIService.subscribeFavorites { imageModels in
                        observer.onNext(imageModels)
                    }
                } else {
                    observer.onCompleted()
                }
                
                return Disposables.create()
            }.map { Mutation.setImageModels(with: $0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setImageModels(imageModels):
            newState.imageModels = imageModels
        }
        
        return newState
    }
}

