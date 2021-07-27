//
//  StorageManager.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/18.
//

import Foundation
import RealmSwift

final class StorageManager {
    
    enum StorageError: Error {
        case NoRealm
    }
    
    private let realm: Realm?
    private var notificationTokens: [NotificationToken?] = []
    
    init() {
        self.realm = try? Realm()
    }
    
    func fetchData<T: Object>(completion: @escaping (Result<[T], Error>) -> ()) {
        guard let realm = realm else {
            completion(.failure(StorageError.NoRealm))
            return
        }
        
        let fetched = realm.objects(T.self)
        completion(.success(Array(fetched)))
    }
    
    func contains<T: Object>(type: T.Type, key: String) -> Bool {
        return read(type: type, key: key) != nil
    }
    
    func read<T: Object>(type: T.Type, key: String) -> T? {
        return realm?.object(ofType: T.self, forPrimaryKey: key)
    }
    
    @discardableResult
    func create(_ object: Object) -> Bool {
        do {
            try realm?.write {
                realm?.add(object, update: .modified)
            }
            return true
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func delete(_ object: Object) -> Bool {
        do {
            try realm?.write {
                realm?.delete(object)
            }
            return true
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
    func subscribe<T: Object>(for type: T.Type,
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
