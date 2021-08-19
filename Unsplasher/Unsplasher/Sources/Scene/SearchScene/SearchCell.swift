//
//  SearchCell.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import UIKit

final class SearchCell: UICollectionViewCell {
    
    static let defaultImage: UIImage? = .init(systemName: "photo")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray3)
    
    private let imageView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFill
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
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.image = Self.defaultImage
    }
    
    func configure(imageURLStr: String) {
        ImageService.loadImage(urlStr: imageURLStr) { [weak self] (image, urlStr) in
            guard urlStr == imageURLStr else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        self.imageView.image = Self.defaultImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
    }
    
}
