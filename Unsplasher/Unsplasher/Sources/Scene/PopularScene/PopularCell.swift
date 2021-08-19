//
//  PopularCell.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/22.
//

import UIKit

final class PopularCell: UITableViewCell {
    
    static let defaultImage: UIImage? = .init(systemName: "photo")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray3)
    
    private lazy var containerView: UIView = .init().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    private let contentImageView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.image = defaultImage
    }
    private let titleLabel: UILabel = .init().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .preferredFont(forTextStyle: .title3)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        layoutMargins = .zero
        separatorInset = .zero
        preservesSuperviewLayoutMargins = false
        
        containerView.addSubview(contentImageView)
        containerView.addSubview(titleLabel)

        contentImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentImageView.snp.width).multipliedBy(0.75)
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentImageView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.top.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(containerView.snp.width).multipliedBy(0.9)
        }
    }
    
    func configure(imageURLStr: String, title: String?) {
        titleLabel.text = title ?? "- No Description -"
        ImageService.loadImage(urlStr: imageURLStr) { [weak self] (image, urlStr) in
            guard urlStr == imageURLStr else { return }
            DispatchQueue.main.async {
                self?.contentImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        contentImageView.image = Self.defaultImage
        titleLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowPath = UIBezierPath(roundedRect: containerView.frame, cornerRadius: 15).cgPath
    }
    
}
