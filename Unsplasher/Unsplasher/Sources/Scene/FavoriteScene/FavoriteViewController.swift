//
//  FavoriteViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

final class FavoriteViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var imageCollectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .systemBackground
        $0.backgroundView = placeHolderView
        $0.dataSource = self
        $0.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
    }
    private let collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    private let placeHolderView: UIView = UILabel().then {
        $0.text = "Empty,, 🧐"
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    
    init(reactor: FavoriteViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
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
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind Reactor

extension FavoriteViewController: View {
    func bind(reactor: FavoriteViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: FavoriteViewReactor) {
        Observable.just(())
            .map { Reactor.Action.subscribeFavorites }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageCollectionView.rx.itemSelected
            .withLatestFrom(reactor.state.map(\.imageModels)) { selectedIndexPath, imageModels in
                return imageModels[selectedIndexPath.item]
            }
            .subscribe(onNext: { [weak self] selectedItem in
                self?.present(DetailVC(imageModel: selectedItem), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: FavoriteViewReactor) {
        reactor
            .pulse(\.$imageModels)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageModels in
                self?.imageCollectionView.reloadData()
                
                self?.placeHolderView.isHidden = !imageModels.isEmpty
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView DataSource

extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.imageModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        
        if let item = reactor?.currentState.imageModels[indexPath.row] {
            cell.configure(imageURLStr: item.urls?.thumb ?? "")
        }
        return cell
    }
    
}
