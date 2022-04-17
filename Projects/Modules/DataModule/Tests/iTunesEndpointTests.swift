//
//  iTunesEndpointTests.swift
//  DataModuleTests
//
//  Created by 홍경표 on 2022/03/22.
//  Copyright © 2022 pio. All rights reserved.
//

import XCTest

@testable import DataModule

import NetworkModule

class iTunesEndpointTests: XCTestCase {
    
    func test_when_검색_카카오뱅크__then_결과_카카오뱅크첫번째() {
        // given
        let apiConfig = APINetworkConfig(baseURL: URL(string: "https://itunes.apple.com")!)
        let networkManager = NetworkManager(config: apiConfig)
        
        // when
        let request = SearchAppRequest(query: "카카오뱅크", media: .app, entity: .iosApp)
        let endpoint = itunesEndpoint.searchApp(request: request)
        
        let expectation = expectation(description: "네트워크 정상일 때 카카오뱅크 검색 시 response data의 첫번째 인덱스에 카카오뱅크 정보")
        _ = networkManager.fetchData(from: endpoint) { (result: Result<SearchAppResponse, Error>) in
            switch result {
            case let .success(response):
                // then
                XCTAssertEqual(response.results[0].appName, "카카오뱅크")
                
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
