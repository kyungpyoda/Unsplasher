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
    
    enum GlobalPropertyError: LocalizedError {
        case NoInfoPlist
        case NoAPIKey
        
        public var errorDescription: String? {
            switch self {
            case .NoInfoPlist:
                return "There is no Info.plist file."
            case .NoAPIKey:
                return "There is no API Key."
            }
        }
    }
    
    /// APIKey 값은 Pods-Unsplasher.debug.xcconfig, Pods-Unsplasher.release.xcconfig 파일 안에 설정
    let apiKey: String
    
    init(isTest: Bool = false) throws {
        guard let infoPlist = Bundle.main.infoDictionary else {
            throw GlobalPropertyError.NoInfoPlist
        }
        
        guard let key = infoPlist["UnsplashAPIKey"] as? String else {
            throw GlobalPropertyError.NoAPIKey
        }
        
        apiKey = isTest ? "TestKey" : key
    }
    
}
