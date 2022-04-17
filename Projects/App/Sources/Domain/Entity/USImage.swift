//
//  USImage.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

struct USImage: Hashable {
    var id: String
    var desc: String?
    var urls: ImageURLPackage?
}

struct ImageURLPackage: Hashable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
