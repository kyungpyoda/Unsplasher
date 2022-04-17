//
//  SearchViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

import DomainModule

import RxSwift
import RxCocoa
import ReactorKit

final class SearchViewController: UIViewController {
    
    // MARK: - Constants
    
    enum ImageListSection {
        case main
    }
    private typealias ImageListDataSource = UICollectionViewDiffableDataSource<ImageListSection, USImage>
    private typealias ImageListSnapshot = NSDiffableDataSourceSnapshot<ImageListSection, USImage>
    
    // MARK: - Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Views
    
    private let searchBar: UISearchBar = .init().then {
        $0.placeholder = "Search"
    }
    private lazy var imageCollectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .systemBackground
        $0.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        $0.keyboardDismissMode = .onDrag
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
    private lazy var dataSource: ImageListDataSource = ImageListDataSource(
        collectionView: imageCollectionView
    ) { [weak self] collectionView, indexPath, imageModel in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCell.reuseIdentifier,
            for: indexPath
        )
        guard let listCell = cell as? SearchCell else { return cell }
        
        listCell.configure(imageURLStr: imageModel.urls?.thumb ?? "")
        return listCell
    }
    private let noResultsView: UIView = UILabel().then {
        $0.text = "No results found. 😅"
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    
    // MARK: - Initialize
    
    init(reactor: SearchViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Set up
    
    private func setUp() {
        setUpUI()
        setUpKeyboardHandler()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(imageCollectionView)
        imageCollectionView.addSubview(noResultsView)
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        noResultsView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setUpKeyboardHandler() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - Bind Reactor

extension SearchViewController: View {
    func bind(reactor: SearchViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SearchViewReactor) {
        searchBar.rx.text.orEmpty
            .map { Reactor.Action.inputQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .map { Reactor.Action.search(query: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageCollectionView.rx.willDisplayCell
            .filter { cell, index in index.item >= (reactor.currentState.usImages.count - 1) }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] selectedIndexPath in
                if let reactor = self?.reactor?.makeDetailViewReactor(for: selectedIndexPath) {
                    self?.present(DetailViewController(reactor: reactor), animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SearchViewReactor) {
        reactor
            .pulse(\.$dataSourceUpdate)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] updateType, usImages in
                guard let self = self else { return }
                
                switch updateType {
                case .reset:
                    var snapshot = ImageListSnapshot()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(usImages, toSection: .main)
                    self.dataSource.apply(snapshot)
                    if !usImages.isEmpty {
                        self.imageCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
                    }
                    self.noResultsView.isHidden = !usImages.isEmpty
                    
                case .append:
                    var snapshot = self.dataSource.snapshot()
                    snapshot.appendItems(usImages, toSection: .main)
                    self.dataSource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Handle Keyboard Noti

extension SearchViewController {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo,
              let size = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        imageCollectionView.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(size.cgRectValue.height - self.view.safeAreaInsets.bottom)
        }
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: curve), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let info = notification.userInfo,
              let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        imageCollectionView.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(0)
        }
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: curve), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}
