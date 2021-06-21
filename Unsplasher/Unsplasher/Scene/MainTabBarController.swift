//
//  MainTabBarController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Tab: CaseIterable {
        case search
        case popular
        case favorite
        
        var tabBarItem: UITabBarItem {
            switch self {
            case .search:
                return .init(
                    title: "",
                    image: .init(named: "search"),
                    selectedImage: .init(named: "search")
                )
            case .popular:
                return .init(
                    title: "",
                    image: .init(named: "fire"),
                    selectedImage: .init(named: "fire")
                )
            case .favorite:
                return .init(
                    title: "",
                    image: .init(named: "heart"),
                    selectedImage: .init(named: "heart")
                )
            }
        }
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
        let tabs: [UIViewController] = Tab.allCases.map { tab in
            switch tab {
            case .search:
                let vc = SearchViewController()
                vc.tabBarItem = tab.tabBarItem
                return vc
            case .popular:
                let vc = PopularViewController()
                vc.tabBarItem = tab.tabBarItem
                return vc
            case .favorite:
                let vc = FavoriteViewController()
                vc.tabBarItem = tab.tabBarItem
                return vc
            }
        }
        
        setViewControllers(
            tabs,
            animated: false
        )
    }
    
}
