//
//  SearchImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

protocol SearchImageRepository {
    func searchImage(
        query: String,
        page: Int
    ) -> Observable<[USImage]>
}
