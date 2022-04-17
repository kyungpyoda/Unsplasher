//
//  PersistingRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import DatabaseModule

protocol PersistingRepository {
    var storageManager: StorageManagerType { get }
}
