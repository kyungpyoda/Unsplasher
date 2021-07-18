//
//  ServiceProvider.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/03.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var globalPropertyService: GlobalPropertyServiceType { get }
    var unsplashAPIService: UnsplashAPIServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    
    let globalPropertyService: GlobalPropertyServiceType
    lazy var unsplashAPIService: UnsplashAPIServiceType = UnsplashAPIService(provider: self)
    
    init(
        globalPropertyService: GlobalPropertyServiceType
    ) {
        self.globalPropertyService = globalPropertyService
    }
    
}
