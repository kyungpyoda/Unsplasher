//
//  GlobalPropertyServiceTests.swift
//  UnsplasherTests
//
//  Created by 홍경표 on 2021/08/02.
//

import XCTest
@testable import Unsplasher

class GlobalPropertyServiceTests: XCTestCase {
    
    func test_GlobalPropertyService_Init_Success() {
        do {
            // Info.plist에서 키 가져오는 것
            let globalPropertyService: GlobalPropertyServiceType = try GlobalPropertyService(isTest: true)
            XCTAssertEqual(globalPropertyService.apiKey, "TestKey")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
}
