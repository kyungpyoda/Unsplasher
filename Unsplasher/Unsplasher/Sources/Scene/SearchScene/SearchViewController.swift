//
//  SearchViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let provider: ServiceProviderType
    
    private var nextPage: Int = 1
    private var searchedQuery: String = ""
    private var items: [ImageModel] = [] {
        didSet {
            let isEmpty = items.isEmpty
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.backgroundView = isEmpty ? self?.noResultsView : nil
            }
        }
    }
    
    // MARK: - Views
    private let searchBar: UISearchBar = .init().then {
        $0.placeholder = "Search"
    }
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .systemBackground
    }
    private let placeHolderView: UIView = UILabel().then {
        $0.text = "Search anything. 🥸"
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    private let noResultsView: UIView = UILabel().then {
        $0.text = "No results found. 😅"
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    
    // MARK: - Initialize
    init(provider: ServiceProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
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
        setUpSearchHandling()
        setUpCollectionView()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundView = placeHolderView
        
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
    
    private func setUpSearchHandling() {
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setUpCollectionView() {
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSize = view.bounds.width / 2 * 0.8
            let spacing = (view.bounds.width - itemSize * 2) / 3
            flowLayout.itemSize = .init(width: itemSize, height: itemSize)
            flowLayout.sectionInset = .init(top: spacing / 2, left: spacing, bottom: spacing / 2, right: spacing)
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    // MARK: - Methods
    private func search() {
        print("Search: \(searchedQuery), Page: \(nextPage)")
        provider.unsplashAPIService.searchImage(query: searchedQuery, page: nextPage) { [weak self] result in
            switch result {
            case .success(let imageModels):
                let thisPage = self?.nextPage ?? 1
                if !imageModels.isEmpty { self?.nextPage += 1 }
                guard thisPage > 1 else {
                    self?.items = imageModels
                    DispatchQueue.main.async {
                        self?.collectionView.setContentOffset(.zero, animated: false)
                        self?.collectionView.reloadData()
                    }
                    return
                }
                let beforeCount = self?.items.count ?? 0
                self?.items += imageModels
                let newIndices = (0..<imageModels.count).map { IndexPath(row: beforeCount + $0, section: 0) }
                DispatchQueue.main.async {
                    self?.collectionView.performBatchUpdates {
                        self?.collectionView.insertItems(at: newIndices)
                    }
                }
                
            case .failure(let error):
                debugPrint(error.localizedDescription as Any)
            }
        }
    }
    
}

// MARK: - CollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        cell.configure(imageURLStr: item.urls?.thumb ?? "")
        return cell
    }
}

// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard (indexPath.item == items.count - 1),
              !searchedQuery.isEmpty else { return }
        search()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = items[indexPath.item]
        present(DetailVC(imageModel: selected), animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let textInput = searchBar.text,
              !textInput.isEmpty else { return }
        
        searchBar.endEditing(true)
        searchedQuery = textInput
        nextPage = 1
        search()
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
        collectionView.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(size.cgRectValue.height)
        }
        self.view.layoutIfNeeded()
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
        collectionView.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(0)
        }
        view.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: curve), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}
