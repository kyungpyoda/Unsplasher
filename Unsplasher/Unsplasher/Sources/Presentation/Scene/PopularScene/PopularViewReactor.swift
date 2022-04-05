//
//  PopularViewReactor.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/03.
//

import Foundation

import RxSwift
import ReactorKit

final class PopularViewReactor: Reactor {
    
    enum Action {
        case loadNextPage
    }
    
    enum Mutation {
        case addImageModels(with: [ImageModel])
        case setPage(to: Int)
    }
    
    struct State {
        @Pulse var page: Int
        @Pulse var imageModels: [ImageModel]
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let serviceProvider: ServiceProviderType
    
    init(
        serviceProvider: ServiceProviderType
    ) {
        self.initialState = State(
            page: 1,
            imageModels: []
        )
        self.serviceProvider = serviceProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNextPage:
            return Observable<Mutation>.create { [weak self] observer in
                if let self = self {
                    self.serviceProvider.unsplashAPIService.getPopulars(
                        page: self.currentState.page
                    ) { result in
                        switch result {
                        case let .success(imageModels):
                            observer.onNext(.addImageModels(with: imageModels))
                            observer.onCompleted()
                            
                        case let .failure(error):
                            observer.onError(error)
                        }
                    }
                } else {
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            .flatMap { [weak self] imageModelMutation -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                return Observable.concat(
                    .just(imageModelMutation),
                    .just(.setPage(to: self.currentState.page + 1))
                )
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .addImageModels(imageModels):
            newState.imageModels.append(contentsOf: imageModels)
            
        case let .setPage(newPage):
            newState.page = newPage
        }
        
        return newState
    }
    
    func makeDetailViewReactor(for selectedIndexPath: IndexPath) -> DetailViewReactor {
        let selectedItem = currentState.imageModels[selectedIndexPath.item]
        return DetailViewReactor(serviceProvider: serviceProvider, imageModel: selectedItem)
    }
}

