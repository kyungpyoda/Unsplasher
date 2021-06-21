//
//  SearchViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = .init()
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .systemBackground
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setUpUI()
        setUpCollectionView()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpCollectionView() {
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
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
    
}

// MARK: - CollectionView DataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}
