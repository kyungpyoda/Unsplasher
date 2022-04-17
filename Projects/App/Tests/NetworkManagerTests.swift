//
//  NetworkManagerTests.swift
//  UnsplasherTests
//
//  Created by 홍경표 on 2021/08/01.
//

import XCTest
@testable import Unsplasher

class NetworkManagerTests: XCTestCase {
    
    /// 가짜 네트워크 통신, 성공
    func test_NetworkManager_make_success() {
        let expectation = expectation(description: "NetworkManager make success")
        
        let networkManager = NetworkManager(urlSession: MockURLSession(makeSuccess: true))
        let endpoint = UnsplashEndpoint.getPopular(page: 1) // 중요하지 않음.
        
        let expected = try! JSONDecoder().decode([ImageModel].self, from: UnsplashEndpoint.sampleImageModel)
        
        networkManager.fetchData(urlRequest: endpoint.urlRequest) { (result: Result<[ImageModel]?, Error>) in
            switch result {
            case .success(let responseData):
                XCTAssertNotNil(responseData)
                XCTAssertEqual(responseData![0].id, expected[0].id)
                XCTAssertEqual(responseData![0].desc, expected[0].desc)
                XCTAssertEqual(responseData![1].id, expected[1].id)
                XCTAssertEqual(responseData![1].desc, expected[1].desc)
                expectation.fulfill()
            case .failure:
                XCTFail("No way")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    /// 가짜 네트워크 통신, 실패
    func test_NetworkManager_make_failure() {
        let expectation = expectation(description: "NetworkManager make failure")
        
        let networkManager = NetworkManager(urlSession: MockURLSession(makeSuccess: false))
        let endpoint = UnsplashEndpoint.getPopular(page: 1) // 중요하지 않음.
        
        let expected = UnsplashEndpoint.sampleError
        
        networkManager.fetchData(urlRequest: endpoint.urlRequest) { (result: Result<[ImageModel]?, Error>) in
            switch result {
            case .success:
                XCTFail("No way")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, expected.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    /// 실제 네트워크 통신, 성공
    func test_NetworkManager_fetchData_success() {
        struct MockModel: Codable, Equatable {
            var userId: Int
            var id: Int
            var title: String
            var body: String
        }
        
        let expectation = expectation(description: "NetworkManager fetchData make success")
        
        let networkManager = NetworkManager()
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
        
        let expected = MockModel(
            userId: 1,
            id: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        )
        
        networkManager.fetchData(urlRequest: request) { (result: Result<MockModel?, Error>) in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, expected)
                expectation.fulfill()
            case .failure:
                XCTFail("No way")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    /// 실제 네트워크 통신, decode 실패
    func test_NetworkManager_fetchData_decodeFail() {
        struct WrongModel: Codable {
            var userId: String
            var id: String
            var title: Int
            var body: Int
        }
        
        let expectation = expectation(description: "NetworkManager fetchData make decodeFail ")
        
        let networkManager = NetworkManager()
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
        
        networkManager.fetchData(urlRequest: request) { (result: Result<WrongModel?, Error>) in
            switch result {
            case .success:
                XCTFail("No way")
                expectation.fulfill()
            case .failure(let error):
                if case .typeMismatch = (error as! DecodingError) {
                    XCTAssert(true)
                } else {
                    XCTFail("asdf")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
