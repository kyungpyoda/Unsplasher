//
//  NetworkManager.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import Foundation

final class NetworkManager {
    
    let urlSession: URLSessionType
    
    init(urlSession: URLSessionType = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchData<T: Decodable>(urlRequest: URLRequest,
                                 completion: @escaping (Result<T?, Error>) -> ()) {
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { return completion(.failure(error!)) }
            
            guard let data = data else { return completion(.success(nil)) }
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                return completion(.success(parsedData))
            } catch(let catchedError) {
                return completion(.failure(catchedError))
            }
        }.resume()
    }
    
}

protocol URLSessionType {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionType { }
