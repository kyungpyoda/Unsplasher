//
//  UnsplashAPIServiceTests.swift
//  UnsplasherTests
//
//  Created by 홍경표 on 2021/08/01.
//

import XCTest
@testable import Unsplasher
import RealmSwift

class UnsplashAPIServiceTests: XCTestCase {
    
    func test_search() {
        let mockNetworkManager = MockNetworkManager()
        let unsplashService = UnsplashAPIService(
            apiKey: "",
            networkManager: mockNetworkManager
        )
        
        let expectation = expectation(description: "Search Images")
        
        unsplashService.searchImage(query: "no2", page: 1) { result in
            switch result {
            case .success(let imageModels):
                let expected = [mockNetworkManager.dummy[1]![1]]
                XCTAssertEqual(imageModels, expected)
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_getPopulars() {
        let mockNetworkManager = MockNetworkManager()
        let unsplashService = UnsplashAPIService(
            apiKey: "",
            networkManager: mockNetworkManager
        )
        
        let expectation = expectation(description: "Get Popular Images")
        
        unsplashService.getPopulars(page: 2) { result in
            switch result {
            case .success(let imageModels):
                let expected = mockNetworkManager.dummy[2]
                XCTAssertEqual(imageModels, expected)
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func test_subscribeFavorites() {
        let config: Realm.Configuration = .init(inMemoryIdentifier: self.name)
        let realm = try! Realm(configuration: config)
        let storageManager = StorageManager(realm: realm)
        let unsplashService = UnsplashAPIService(
            apiKey: "",
            storageManager: storageManager
        )
        
        let expectation = expectation(description: "Subscribe for Favorites")
        
        var count = 0
        let willCreated = ImageModel()
        
        unsplashService.subscribeFavorites { imageModels in
            switch count {
            case 0:
                XCTAssertTrue(imageModels.isEmpty)
                
            case 1:
                XCTAssertEqual(imageModels, [willCreated])
                expectation.fulfill()
                
            default:
                break
            }
        }
        
        storageManager.create(willCreated)
        count = 1
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
