//
//  NetworkingRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import NetworkModule
import ThirdPartyManager

import RxSwift

protocol NetworkingRepository: AnyObject {
    var networkManager: NetworkManagerType { get }
    func fetchRemote<T: EntityConvertible & Decodable>(from endpoint: EndpointType) -> Observable<T>
}

extension NetworkingRepository {
    func fetchRemote<T: EntityConvertible & Decodable>(from endpoint: EndpointType) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            let task = self?.networkManager.fetchData(from: endpoint) { (result: Result<T, Error>) in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                    observer.onCompleted()
                    
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
