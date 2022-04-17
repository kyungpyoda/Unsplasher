//
//  NetworkManagerTests.swift
//  NetworkModuleTests
//
//  Created by 홍경표 on 2022/03/21.
//  Copyright © 2022 pio. All rights reserved.
//

import XCTest

@testable import NetworkModule

class NetworkManagerTests: XCTestCase {
    struct Post: Codable, Equatable {
        var userId: Int
        var id: Int
        var title: String
        var body: String
    }
    
    enum PostEndpoint: EndpointType {
        case getPost(id: Int)
        
        var path: String {
            switch self {
            case let .getPost(id):
                return "posts/\(id)"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .getPost: return .get
            }
        }
        
        var httpTask: HTTPTask {
            switch self {
            case .getPost:
                return .request
            }
        }
        
        var headers: HTTPHeaders? {
            return nil
        }
    }
    
    /// 실제 네트워크 통신, 성공
    func test_given_실제네트워크__when_정상Endpoint__then_정상결과() {
        // given
        let networkConfig = APINetworkConfig(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
        let networkManager = NetworkManager(config: networkConfig)
        
        let expectation = expectation(description: "NetworkManager fetchData should make success")
        
        let expected = Post(
            userId: 1,
            id: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        )
        
        // when
        _ = networkManager.fetchData(from: PostEndpoint.getPost(id: 1)) { (result: Result<Post, Error>) in
            switch result {
            case .success(let responseData):
                // then
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

}
