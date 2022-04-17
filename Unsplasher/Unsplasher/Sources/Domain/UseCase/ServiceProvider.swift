//
//  ServiceProvider.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/03.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var unsplashAPIService: UnsplashAPIServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    
    let unsplashAPIService: UnsplashAPIServiceType
    
    init(
        unsplashAPIService: UnsplashAPIServiceType
    ) {
        self.unsplashAPIService = unsplashAPIService
    }
    
}
