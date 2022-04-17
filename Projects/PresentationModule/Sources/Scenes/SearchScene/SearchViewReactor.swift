//
//  SearchViewReactor.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/03.
//

import Foundation

import DomainModule
import InjectionManager
import ThirdPartyManager

import RxSwift
import ReactorKit

final class SearchViewReactor: Reactor {
    
    enum DataSourceUpdateType {
        case reset
        case append
    }
    typealias DataSourceUpdate = (type: DataSourceUpdateType, items: [USImage])
    
    enum Action {
        case inputQuery(String)
        case search(query: String)
        case loadNextPage
    }
    
    enum Mutation {
        case setInputQuery(to: String)
        case setImages(with: [USImage])
        case addImages(with: [USImage])
        case setPage(to: Int)
    }
    
    struct State {
        @Pulse var inputQuery: String
        @Pulse var page: Int
        @Pulse var usImages: [USImage]
        @Pulse var dataSourceUpdate: DataSourceUpdate?
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let searchImageUseCase: SearchImageUseCase
    
    init(
        searchImageUseCase: SearchImageUseCase = DIContainer.resolve(SearchImageUseCase.self)
    ) {
        self.initialState = State(
            inputQuery: "",
            page: 1,
            usImages: [],
            dataSourceUpdate: nil
        )
        self.searchImageUseCase = searchImageUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputQuery(query):
            return .just(.setInputQuery(to: query))
            
        case let .search(query):
            return searchImageUseCase.searchImage(query: query, page: self.currentState.page)
                .flatMap { [weak self] usImages -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    return Observable.concat(
                        .just(.setImages(with: usImages)),
                        .just(.setPage(to: self.currentState.page + 1))
                    )
                }
            
        case .loadNextPage:
            return searchImageUseCase.searchImage(query: self.currentState.inputQuery, page: self.currentState.page)
                .flatMap { [weak self] usImages -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    return Observable.concat(
                        .just(.addImages(with: usImages)),
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
            
        case let .setImages(usImages):
            newState.usImages = usImages
            newState.dataSourceUpdate = (type: .reset, items: usImages)
            
        case let .addImages(usImages):
            newState.usImages.append(contentsOf: usImages)
            newState.dataSourceUpdate = (type: .append, items: usImages)
            
        case let .setPage(newPage):
            newState.page = newPage
        }
        
        return newState
    }
    
    func makeDetailViewReactor(for selectedIndexPath: IndexPath) -> DetailViewReactor {
        let selectedItem = currentState.usImages[selectedIndexPath.item]
        return DetailViewReactor(usImage: selectedItem)
    }
}

