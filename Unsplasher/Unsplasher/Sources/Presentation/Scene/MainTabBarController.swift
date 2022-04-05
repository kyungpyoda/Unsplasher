//
//  MainTabBarController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Tab: CaseIterable {
        static let searchImage: UIImage? = .init(named: "search")?.withRenderingMode(.alwaysTemplate)
        static let fireImage: UIImage? = .init(named: "fire")?.withRenderingMode(.alwaysTemplate)
        static let heartImage: UIImage? = .init(named: "heart")?.withRenderingMode(.alwaysTemplate)
        
        case search
        case popular
        case favorite
        
        var tabBarItem: UITabBarItem {
            switch self {
            case .search:
                return .init(
                    title: "",
                    image: Tab.searchImage,
                    selectedImage: Tab.searchImage
                )
            case .popular:
                return .init(
                    title: "",
                    image: Tab.fireImage,
                    selectedImage: Tab.fireImage
                )
            case .favorite:
                return .init(
                    title: "",
                    image: Tab.heartImage,
                    selectedImage: Tab.heartImage
                )
            }
        }
    }
    
    private let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        setUp()
    }
    
    private func setUp() {
        let tabs: [UIViewController] = Tab.allCases.map { tab in
            switch tab {
            case .search:
                let reactor = SearchViewReactor(serviceProvider: provider)
                let vc = SearchViewController(reactor: reactor)
                vc.tabBarItem = tab.tabBarItem
                return vc
            case .popular:
                let reactor = PopularViewReactor(serviceProvider: provider)
                let vc = PopularViewController(reactor: reactor)
                vc.tabBarItem = tab.tabBarItem
                return vc
            case .favorite:
                let reactor = FavoriteViewReactor(serviceProvider: provider)
                let vc = FavoriteViewController(reactor: reactor)
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
