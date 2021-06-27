//
//  Cell+Reusable.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}
extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

extension UITableViewCell: Reusable { }
extension UICollectionViewCell: Reusable { }
