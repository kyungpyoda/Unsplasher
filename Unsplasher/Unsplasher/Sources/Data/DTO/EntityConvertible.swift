//
//  EntityConvertible.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

protocol EntityConvertible {
    associatedtype Entity
    
    func toDomain() -> Entity
}

extension Array: EntityConvertible where Element: EntityConvertible {
    func toDomain() -> [Element.Entity] {
        return self.map {
            $0.toDomain()
        }
    }
}
