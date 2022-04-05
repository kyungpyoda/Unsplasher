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
        case setImageModel(to: ImageModel)
        case setIsFavorite(to: Bool)
    }
    
    struct State {
        @Pulse var imageModel: ImageModel
        @Pulse var isFavorite: Bool
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let serviceProvider: ServiceProviderType
    
    init(
        serviceProvider: ServiceProviderType,
        imageModel: ImageModel
    ) {
        let unmanaged = ImageModel(value: imageModel)
        self.initialState = State(
            imageModel: unmanaged,
            isFavorite: serviceProvider.unsplashAPIService.checkImageIsFavorite(imageModel)
        )
        self.serviceProvider = serviceProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleFavorite:
            return Observable<(ImageModel, Bool)>
                .just(
                    serviceProvider.unsplashAPIService.toggleFavorite(of: currentState.imageModel)
                )
                .flatMap { result -> Observable<Mutation> in
                    return .merge(
                        .just(.setImageModel(to: result.0)),
                        .just(.setIsFavorite(to: result.1))
                    )
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setImageModel(imageModel):
            newState.imageModel = imageModel
            
        case let .setIsFavorite(isFavorite):
            newState.isFavorite = isFavorite
        }
        
        return newState
    }
}


