//
//  ImageModel.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/04.
//

import Foundation

struct ImageSearchModel: Decodable {
    var total: Int
    var totalPages: Int
    var results: [ImageModel]
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct ImageModel: Decodable {
    var id: String
    var description: String?
    var urls: ImageURLs
}

struct ImageURLs: Decodable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
