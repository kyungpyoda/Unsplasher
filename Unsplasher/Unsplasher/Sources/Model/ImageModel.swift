//
//  ImageModel.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/04.
//

import Foundation
import RealmSwift

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

final class ImageModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var desc: String?
    @objc dynamic var urls: ImageURLs?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.desc = try container.decode(String?.self, forKey: .desc)
        self.urls = try container.decode(ImageURLs.self, forKey: .urls)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case desc = "description"
        case urls
    }
}

final class ImageURLs: Object, Codable {
    @objc dynamic var raw: String = ""
    @objc dynamic var full: String = ""
    @objc dynamic var regular: String = ""
    @objc dynamic var small: String = ""
    @objc dynamic var thumb: String = ""
}
