//
//  GlobalPropertyService.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/27.
//

import Foundation

protocol GlobalPropertyServiceType {
    var apiKey: String { get }
}

final class GlobalPropertyService: GlobalPropertyServiceType {
    
    /// APIKey 값은 Pods-Unsplasher.debug.xcconfig, Pods-Unsplasher.release.xcconfig 파일 안에 설정
    let apiKey: String
    
    init() throws {
        guard let infoPlist = Bundle.main.infoDictionary,
              let key = infoPlist["UnsplashAPIKey"] as? String else {
            throw GlobalPropertyError.APIKeyError
        }
        
        apiKey = key
    }
    
}

enum GlobalPropertyError: LocalizedError {
    case APIKeyError
}
