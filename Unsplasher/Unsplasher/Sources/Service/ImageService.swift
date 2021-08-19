//
//  ImageService.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/04.
//

import UIKit

final class ImageService {
    
    static let imageCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 1000
        return cache
    }()
    
    static func loadImage(urlStr: String,
                          completion: @escaping (UIImage?, String) -> Void) {
        guard let url = URL(string: urlStr) else {
            completion(nil, urlStr)
            return
        }
        
        if let cached = imageCache.object(forKey: url as NSURL) {
            completion(cached, urlStr)
            return
        }
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil,
                      let data = data,
                      let image = UIImage(data: data) else {
                    completion(nil, urlStr)
                    return
                }
                
                completion(image, urlStr)
                
                imageCache.setObject(image, forKey: url as NSURL)
            }
            task.resume()
        }
    }
    
}
