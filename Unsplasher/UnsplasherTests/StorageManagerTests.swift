//
//  StorageManagerTests.swift
//  UnsplasherTests
//
//  Created by 홍경표 on 2021/08/14.
//

import XCTest
@testable import Unsplasher
import RealmSwift

final class TestObject: Object {
    @objc dynamic var id: UUID = UUID()
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(name: String) {
        self.init()
        self.name = name
    }
}

class StorageManagerTests: XCTestCase {
    
    private var realm: Realm!
    var storageManager: StorageManagerType!
    
    override func setUp() {
        let config: Realm.Configuration = .init(inMemoryIdentifier: self.name)
        realm = try! Realm(configuration: config)
        storageManager = StorageManager(realm: realm)
    }
    
    override func tearDown() {
    }
    
    func test_fetch_success() {
        let dummySet: Set<TestObject> = [.init(name: "dummy1"), .init(name: "dummy2")]
        dummySet.forEach {
            XCTAssertTrue(storageManager.create($0))
        }
        storageManager.fetchData { (result: Result<[TestObject], Error>) in
            switch result {
            case .success(let fetched):
                let fetchedSet = Set(fetched)
                XCTAssertEqual(dummySet, fetchedSet)
            case .failure:
                XCTFail("Have to be succeeded")
            }
        }
    }
    
    func test_fetch_failure() {
        let storageManager = StorageManager(realm: nil)
        storageManager.fetchData { result in
            switch result {
            case .success:
                XCTFail("Have to be failed")
            case .failure(let error):
                XCTAssertEqual(error as! StorageManager.StorageError, StorageManager.StorageError.NoRealm)
            }
        }
    }
    
    func test_create_contains() {
        let dummy = TestObject(name: "dummy")
        let id = dummy.id
        XCTAssertTrue(storageManager.create(dummy))
        XCTAssertTrue(storageManager.contains(type: TestObject.self, key: id))
        let fetched = realm.object(ofType: TestObject.self, forPrimaryKey: id)
        XCTAssertEqual(dummy, fetched)
    }
    
    func test_delete_contains() {
        let dummy = TestObject(name: "dummy")
        let id = dummy.id
        XCTAssertTrue(storageManager.create(dummy))
        XCTAssertTrue(storageManager.contains(type: TestObject.self, key: id))
        XCTAssertTrue(storageManager.delete(dummy))
        XCTAssertFalse(storageManager.contains(type: TestObject.self, key: id))
    }
    
    func test_read() {
        let dummy = TestObject(name: "dummy")
        let id = dummy.id
        XCTAssertTrue(storageManager.create(dummy))
        let read = storageManager.read(type: TestObject.self, key: id)
        XCTAssertNotNil(read)
        XCTAssertEqual(read, dummy)
    }
    
    func test_subscribe() {
        var updateCount = 0
        var current: [TestObject] = []
        let expectation = expectation(description: "For Testing Subscribe")
        storageManager.subscribe(for: TestObject.self) { newests in
            switch updateCount {
            case 0:
                XCTAssertTrue(newests.isEmpty)
                
            case 1...3:
                XCTAssertEqual(newests, current)
                
            case 4:
                expectation.fulfill()
                
            default:
                XCTFail()
            }
        }
        
        let dummy1 = TestObject(name: "dummy")
        let dummy2 = TestObject(name: "dummy")
        
        updateCount += 1
        XCTAssertTrue(storageManager.create(dummy1))
        current.append(dummy1)
        
        updateCount += 1
        XCTAssertTrue(storageManager.create(dummy2))
        current.append(dummy2)
        
        updateCount += 1
        XCTAssertTrue(storageManager.delete(dummy1))
        current.removeFirst()
        
        updateCount += 1
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
