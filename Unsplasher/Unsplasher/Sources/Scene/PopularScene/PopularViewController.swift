//
//  PopularViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

final class PopularViewController: UIViewController {
    
    private let provider: ServiceProviderType
    
    private var nextPage: Int = 1
    private var items: [ImageModel] = []
    
    private let tableView: UITableView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
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
        getPopulars()
    }
    
    private func setUp() {
        setUpUI()
        setUpTableView()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpTableView() {
        tableView.register(PopularCell.self, forCellReuseIdentifier: PopularCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getPopulars() {
        print("Page: \(nextPage)")
        provider.unsplashAPIService.getPopulars(page: nextPage) { [weak self] result in
            switch result {
            case .success(let imageModels):
                let thisPage = self?.nextPage ?? 1
                if !imageModels.isEmpty { self?.nextPage += 1 }
                guard thisPage > 1 else {
                    self?.items = imageModels
                    DispatchQueue.main.async {
                        self?.tableView.setContentOffset(.zero, animated: false)
                        self?.tableView.reloadData()
                    }
                    return
                }
                let beforeCount = self?.items.count ?? 0
                self?.items += imageModels
                let newIndices = (0..<imageModels.count).map { IndexPath(row: beforeCount + $0, section: 0) }
                DispatchQueue.main.async {
                    self?.tableView.performBatchUpdates {
                        self?.tableView.insertRows(at: newIndices, with: .automatic)
                    }
                }
                
            case .failure(let error):
                debugPrint(error.localizedDescription as Any)
            }
        }
    }
    
}

// MARK: - TableView DataSource

extension PopularViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularCell.reuseIdentifier, for: indexPath) as? PopularCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(imageURLStr: item.urls?.thumb ?? "", title: item.desc)
        return cell
    }
    
}

// MARK: - TableView Delegate
extension PopularViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (indexPath.row == items.count - 1) else { return }
        getPopulars()
    }
}
