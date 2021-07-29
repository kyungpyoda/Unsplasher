//
//  FavoriteViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    private let provider: ServiceProviderType
    
    private var items: [ImageModel] = [] {
        didSet {
            let isEmpty = items.isEmpty
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.backgroundView = isEmpty ? self?.placeHolderView : nil
            }
        }
    }
    
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .systemBackground
    }
    private let placeHolderView: UIView = UILabel().then {
        $0.text = "Empty,, 🧐"
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        subscribeFavorites()
    }
    
    private func setUp() {
        setUpUI()
        setUpCollectionView()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundView = placeHolderView
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpCollectionView() {
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        collectionView.dataSource = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSize = view.bounds.width / 2 * 0.8
            let spacing = (view.bounds.width - itemSize * 2) / 3
            flowLayout.itemSize = .init(width: itemSize, height: itemSize)
            flowLayout.sectionInset = .init(top: spacing / 2, left: spacing, bottom: spacing / 2, right: spacing)
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    private func subscribeFavorites() {
        provider.unsplashAPIService.subscribeFavorites { [weak self] imageModels in
            self?.items = imageModels
            DispatchQueue.main.async {
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
}


// MARK: - CollectionView DataSource

extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(imageURLStr: item.urls?.thumb ?? "")
        return cell
    }
    
}
