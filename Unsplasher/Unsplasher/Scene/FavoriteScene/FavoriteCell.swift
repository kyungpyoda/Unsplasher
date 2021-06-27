//
//  FavoriteCell.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/26.
//

import UIKit

final class FavoriteCell: UICollectionViewCell {
    
    static let defaultImage: UIImage? = .init(systemName: "photo")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray3)
    
    private let imageView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.backgroundColor = .systemGray5
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.image = Self.defaultImage
    }
    
    func configure(imageURLStr: String) {
        // TODO: implement image loader, fetch image with url
    }
    
    override func prepareForReuse() {
        self.imageView.image = Self.defaultImage
    }
}
