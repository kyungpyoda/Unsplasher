//
//  FetchPopularImageRepository.swift
//  Unsplasher
//
//  Created by 홍경표 on 2022/04/17.
//

import Foundation

import RxSwift

protocol FetchPopularImageRepository {
    func getPopulars(page: Int) -> Observable<[USImage]>
}
