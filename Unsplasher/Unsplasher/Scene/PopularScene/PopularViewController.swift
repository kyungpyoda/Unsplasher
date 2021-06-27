//
//  PopularViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

final class PopularViewController: UIViewController {
    
    private let tableView: UITableView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
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
    }
    
}

// MARK: - TableView DataSource

extension PopularViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularCell.reuseIdentifier, for: indexPath) as? PopularCell else {
            return UITableViewCell()
        }
        cell.configure(imageURLStr: "", title: "A popular picture")
        return cell
    }
    
}
