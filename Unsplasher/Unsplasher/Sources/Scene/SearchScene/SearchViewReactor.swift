//
//  SearchViewReactor.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/03.
//

import Foundation

import RxSwift
import ReactorKit

final class SearchViewReactor: Reactor {
    
    enum DataSourceUpdateType {
        case reset
        case append
    }
    typealias DataSourceUpdate = (type: DataSourceUpdateType, items: [ImageModel])
    
    enum Action {
        case inputQuery(String)
        case search(query: String)
        case loadNextPage
    }
    
    enum Mutation {
        case setInputQuery(to: String)
        case setImageModels(with: [ImageModel])
        case addImageModels(with: [ImageModel])
        case setPage(to: Int)
    }
    
    struct State {
        @Pulse var inputQuery: String
        @Pulse var page: Int
        @Pulse var imageModels: [ImageModel]
        @Pulse var dataSourceUpdate: DataSourceUpdate?
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let serviceProvider: ServiceProviderType
    
    init(
        serviceProvider: ServiceProviderType
    ) {
        self.initialState = State(
            inputQuery: "",
            page: 1,
            imageModels: [],
            dataSourceUpdate: nil
        )
        self.serviceProvider = serviceProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputQuery(query):
            return .just(.setInputQuery(to: query))
            
        case let .search(query):
            return Observable<Mutation>.create { [weak self] observer in
                if let self = self {
                    self.serviceProvider.unsplashAPIService.searchImage(
                        query: query,
                        page: self.currentState.page
                    ) { result in
                        switch result {
                        case let .success(imageModels):
                            observer.onNext(.setImageModels(with: imageModels))
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
            
        case .loadNextPage:
            return Observable<Mutation>.create { [weak self] observer in
                if let self = self {
                    self.serviceProvider.unsplashAPIService.searchImage(
                        query: self.currentState.inputQuery,
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
        case let .setInputQuery(newQuery):
            newState.inputQuery = newQuery
            
        case let .setImageModels(imageModels):
            newState.imageModels = imageModels
            newState.dataSourceUpdate = (type: .reset, items: imageModels)
            
        case let .addImageModels(imageModels):
            newState.imageModels.append(contentsOf: imageModels)
            newState.dataSourceUpdate = (type: .append, items: imageModels)
            
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

