//
//  USImage.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

public struct USImage: Hashable {
    public var id: String
    public var desc: String?
    public var urls: ImageURLPackage?
    
    public init(
        id: String,
        desc: String?,
        urls: ImageURLPackage?
    ) {
        self.id = id
        self.desc = desc
        self.urls = urls
    }
}

public struct ImageURLPackage: Hashable {
    public var raw: String
    public var full: String
    public var regular: String
    public var small: String
    public var thumb: String
    
    public init(
        raw: String,
        full: String,
        regular: String,
        small: String,
        thumb: String
    ) {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}
