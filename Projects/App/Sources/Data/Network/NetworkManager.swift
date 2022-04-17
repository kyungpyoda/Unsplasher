//
//  NetworkManager.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import Foundation

protocol NetworkManagerType {
    func fetchData<T: Decodable>(
        from endpoint: EndpointType,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> NetworkCancellable?
}

final class NetworkManager: NetworkManagerType {
    
    private let config: NetworkConfigurable
    private let urlSession: URLSessionType
    
    init(
        config: NetworkConfigurable,
        urlSession: URLSessionType = URLSession.shared
    ) {
        self.config = config
        self.urlSession = urlSession
    }
    
    private func log(_ endpoint: EndpointType, _ request: URLRequest) {
        #if DEBUG
        print("----Network Request----", endpoint, request, "-----------------------", separator: "\n")
        #endif
    }
    
    func fetchData<T: Decodable>(
        from endpoint: EndpointType,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> NetworkCancellable? {
        do {
            let request = try endpoint.buildRequest(with: config)
            
            log(endpoint, request)
            
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let data = data else {
                    return completion(.failure(NetworkManagerError.NoResponse))
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299) ~= response.statusCode
                else {
                    return completion(.failure(NetworkManagerError.RequestFail))
                }
                
                do {
                    let parsedData = try JSONDecoder().decode(T.self, from: data)
                    return completion(.success(parsedData))
                } catch(let catchedError) {
                    return completion(.failure(NetworkManagerError.Parsing(catchedError)))
                }
            }
            task.resume()
            return task
        } catch(let catchedError) {
            completion(.failure(catchedError))
            return nil
        }
    }
    
}
