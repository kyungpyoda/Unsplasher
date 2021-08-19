//
//  MockURLSession.swift
//  UnsplasherTests
//
//  Created by 홍경표 on 2021/08/01.
//

import Foundation
@testable import Unsplasher

final class MockURLSessionDataTask: URLSessionDataTask {
    private let handler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.handler = resumeHandler
    }
    
    override func resume() {
        handler()
    }
}

final class MockURLSession: URLSessionType {
    
    let makeSuccess: Bool
    
    init(makeSuccess: Bool = true) {
        self.makeSuccess = makeSuccess
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        print(request.url?.path)
        let mockDataTask = MockURLSessionDataTask { [weak self] in
            guard let self = self else { return }
            if self.makeSuccess {
                completionHandler(
                    UnsplashEndpoint.sampleImageModel,
                    HTTPURLResponse(
                        url: request.url!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    ),
                    nil
                )
            } else {
                completionHandler(
                    nil,
                    HTTPURLResponse(
                        url: request.url!,
                        statusCode: UnsplashEndpoint.sampleError.code,
                        httpVersion: nil,
                        headerFields: nil
                    ),
                    UnsplashEndpoint.sampleError
                )
            }
        }
        
        return mockDataTask
    }
}
