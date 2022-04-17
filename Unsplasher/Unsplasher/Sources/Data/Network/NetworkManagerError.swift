//
//  NetworkManagerError.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

enum NetworkManagerError: Error {
    case InvalidRequest(Error?)
    case NoResponse
    case Parsing(Error)
    case RequestFail
}
