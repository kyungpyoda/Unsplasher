//
//  SearchAppRepositoryTests.swift
//  DataModuleTests
//
//  Created by 홍경표 on 2022/03/22.
//  Copyright © 2022 pio. All rights reserved.
//

import XCTest

@testable import DataModule

import DomainModule
import NetworkModule

import RxSwift
import RxBlocking

class SearchAppRepositoryTests: XCTestCase {
    
    func test_when_검색_카카오뱅크__then_결과_카카오뱅크첫번째() {
        // when
        let apiConfig = APINetworkConfig(baseURL: URL(string: "https://itunes.apple.com")!)
        let networkManager = NetworkManager(config: apiConfig)
        let searchAppRepo = DefaultSearchAppRepository(networkManager: networkManager)
        
        // when
        let query = "카카오뱅크"
        let result = try! searchAppRepo.search(query: query).toBlocking().first() ?? []
        
        // then
        let expectedID = 1258016944
        let expectedAppName = "카카오뱅크"
        XCTAssertEqual(expectedID, result[0].id)
        XCTAssertEqual(expectedAppName, result[0].appName)
    }
    
}
