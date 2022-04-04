//
//  PopularViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

final class PopularViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var imageTableView: UITableView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.register(PopularCell.self, forCellReuseIdentifier: PopularCell.reuseIdentifier)
        $0.dataSource = self
    }
    
    init(reactor: PopularViewReactor) {
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
        
        view.addSubview(imageTableView)
        imageTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind Reactor

extension PopularViewController: View {
    func bind(reactor: PopularViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: PopularViewReactor) {
        Observable.just(())
            .map { Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageTableView.rx.willDisplayCell
            .filter { cell, index in index.item >= (reactor.currentState.imageModels.count - 1) }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageTableView.rx.itemSelected
            .withLatestFrom(reactor.state.map(\.imageModels)) { selectedIndexPath, imageModels in
                return imageModels[selectedIndexPath.item]
            }
            .subscribe(onNext: { [weak self] selectedItem in
                self?.present(DetailVC(imageModel: selectedItem), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PopularViewReactor) {
        reactor
            .pulse(\.$imageModels)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.imageTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView DataSource

extension PopularViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.imageModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularCell.reuseIdentifier, for: indexPath) as? PopularCell else {
            return UITableViewCell()
        }
        
        if let item = reactor?.currentState.imageModels[indexPath.row] {
            cell.configure(imageURLStr: item.urls?.thumb ?? "", title: item.desc)
        }
        return cell
    }
    
}
