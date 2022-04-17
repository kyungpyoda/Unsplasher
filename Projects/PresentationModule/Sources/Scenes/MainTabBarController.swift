//
//  MainTabBarController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Tab: CaseIterable {
        static let searchImage: UIImage? = PresentationModuleAsset.search.image
        static let fireImage: UIImage? = PresentationModuleAsset.fire.image
        static let heartImage: UIImage? = PresentationModuleAsset.heart.image
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        setUp()
    }
    
    private func setUp() {
        let tabs: [UIViewController] = Tab.allCases.map { tab in
            switch tab {
            case .search:
                let reactor = SearchViewReactor()
                let vc = SearchViewController(reactor: reactor)
                vc.tabBarItem = tab.tabBarItem
                return vc
                
            case .popular:
                let reactor = PopularViewReactor()
                let vc = PopularViewController(reactor: reactor)
                vc.tabBarItem = tab.tabBarItem
                return vc
                
            case .favorite:
                let reactor = FavoriteViewReactor()
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
