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
    
    private enum CodingKeys: String, CodingKey {
        case id
        case desc = "description"
        case urls
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.desc = try container.decode(String?.self, forKey: .desc)
        self.urls = try? container.decode(ImageURLs.self, forKey: .urls)
    }
    
    convenience init(with usImage: USImage) {
        self.init()
        self.id = usImage.id
        self.desc = usImage.desc
        if let imageURLPackage = usImage.urls {
            self.urls = ImageURLs(with: imageURLPackage)
        }
    }
}

final class ImageURLs: Object, Codable {
    @objc dynamic var raw: String = ""
    @objc dynamic var full: String = ""
    @objc dynamic var regular: String = ""
    @objc dynamic var small: String = ""
    @objc dynamic var thumb: String = ""
    
    convenience init(with imageURLPackage: ImageURLPackage) {
        self.init()
        self.raw = imageURLPackage.raw
        self.full = imageURLPackage.full
        self.regular = imageURLPackage.regular
        self.small = imageURLPackage.small
        self.thumb = imageURLPackage.thumb
    }
}

extension ImageSearchModel: EntityConvertible {
    func toDomain() -> [USImage] {
        return results.toDomain()
    }
}

extension ImageModel: EntityConvertible {
    func toDomain() -> USImage {
        return USImage(
            id: self.id,
            desc: self.desc,
            urls: self.urls?.toDomain()
        )
    }
}

extension ImageURLs: EntityConvertible {
    func toDomain() -> ImageURLPackage {
        return ImageURLPackage(
            raw: self.raw,
            full: self.full,
            regular: self.regular,
            small: self.small,
            thumb: self.thumb
        )
    }
}
