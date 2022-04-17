//
//  AppConfiguration.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

final class AppConfiguration {
    static var apiBaseURL: URL = {
        guard let apiBaseURLStr = Bundle.main.object(forInfoDictionaryKey: "UnsplashBaseURL") as? String
        else { fatalError("Info.plist 혹은 User Defined Key에 UnsplashBaseURL이 비어있음.") }
        
        guard let apiBaseURL = URL(string: apiBaseURLStr)
        else { fatalError("잘못된 API Base URL") }
        
        return apiBaseURL
    }()
    
    static var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "UnsplashAPIKey") as? String else {
            fatalError("API Key가 비어있음.")
        }
        return "Client-ID \(apiKey)"
    }()
}
