//
//  StorageManager.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/18.
//

import Foundation
import RealmSwift

public protocol StorageManagerType {
    func fetchData<T: Object>(completion: @escaping (Result<[T], Error>) -> ()) -> Void
    
    func contains<T: Object>(
        type: T.Type,
        key: Any
    ) -> Bool
    
    func read<T: Object>(
        type: T.Type,
        key: Any
    ) -> T?
    
    func create(_ object: Object) throws -> Void
    
    func delete(_ object: Object) throws -> Void
    
    func subscribe<T: Object>(
        for type: T.Type,
        block: @escaping ([T]) -> Void
    ) -> Void
}

public final class StorageManager: StorageManagerType {
    
    enum StorageError: Error {
        case NoRealm
    }
    
    private let realm: Realm?
    private var notificationTokens: [NotificationToken?] = []
    
    public init(realm: Realm? = try? Realm()) {
        self.realm = realm
    }
    
    public func fetchData<T: Object>(completion: @escaping (Result<[T], Error>) -> ()) {
        guard let realm = realm else {
            completion(.failure(StorageError.NoRealm))
            return
        }
        
        let fetched = realm.objects(T.self)
        completion(.success(Array(fetched)))
    }
    
    public func contains<T: Object>(type: T.Type, key: Any) -> Bool {
        return read(type: type, key: key) != nil
    }
    
    public func read<T: Object>(type: T.Type, key: Any) -> T? {
        return realm?.object(ofType: T.self, forPrimaryKey: key)
    }
    
    public func create(_ object: Object) throws {
        try realm?.write {
            realm?.add(object, update: .modified)
        }
    }
    
    public func delete(_ object: Object) throws {
        try realm?.write {
            realm?.delete(object)
        }
    }
    
    public func subscribe<T: Object>(for type: T.Type,
                                     block: @escaping ([T]) -> Void) {
        let notiToken = realm?.objects(T.self).observe({ changes in
            switch changes {
            case .initial(let data):
                block(Array(data))
            case .update(let data, _, _, _):
                block(Array(data))
            case .error(let error):
                debugPrint(#function, error.localizedDescription)
            }
        })
        notificationTokens.append(notiToken)
    }
    
}
