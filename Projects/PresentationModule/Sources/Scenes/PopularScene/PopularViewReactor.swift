//
//  PopularViewReactor.swift
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

final class PopularViewReactor: Reactor {
    
    enum Action {
        case loadNextPage
    }
    
    enum Mutation {
        case addImages(with: [USImage])
        case setPage(to: Int)
    }
    
    struct State {
        @Pulse var page: Int
        @Pulse var usImages: [USImage]
    }
    
    let initialState: State
    
    // MARK: Dependency
    
    private let fetchPopularImageUseCase: FetchPopularImageUseCase
    
    init(
        fetchPopularImageUseCase: FetchPopularImageUseCase = DIContainer.resolve(FetchPopularImageUseCase.self)
    ) {
        self.initialState = State(
            page: 1,
            usImages: []
        )
        self.fetchPopularImageUseCase = fetchPopularImageUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNextPage:
            return fetchPopularImageUseCase.getPopulars(page: self.currentState.page)
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
        case let .addImages(usImages):
            newState.usImages.append(contentsOf: usImages)
            
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
