//
//  AnyEncodable.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            else {
                throw NetworkManagerError.InvalidRequest(nil)
            }
            return dictionary
        } catch(let catchedError) {
            throw NetworkManagerError.InvalidRequest(catchedError)
        }
    }
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

