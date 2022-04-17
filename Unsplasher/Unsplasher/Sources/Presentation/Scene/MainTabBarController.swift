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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        setUp()
    }
    
    private func setUp() {
        let apiConfig = APINetworkConfig(
            baseURL: AppConfiguration.apiBaseURL,
            headers: [
                HTTPHeaderKey.authorization.rawValue: AppConfiguration.apiKey
            ]
        )
        let networkManager = NetworkManager(config: apiConfig)
        let storageManager = StorageManager()
        
        let tabs: [UIViewController] = Tab.allCases.map { tab in
            switch tab {
            case .search:
                let searhImageRepository = DefaultSearchImageRepository(networkManager: networkManager)
                let searchImageUseCase = DefaultSearchImageUseCase(searchImageRepository: searhImageRepository)
                let reactor = SearchViewReactor(searchImageUseCase: searchImageUseCase)
                let vc = SearchViewController(reactor: reactor)
                vc.tabBarItem = tab.tabBarItem
                return vc
                
            case .popular:
                let fetchPopularImageRepository = DefaultFetchPopularImageRepository(networkManager: networkManager)
                let fetchPopularImageUseCase = DefaultFetchPopularImageUseCase(fetchPopularImageRepository: fetchPopularImageRepository)
                let reactor = PopularViewReactor(fetchPopularImageUseCase: fetchPopularImageUseCase)
                let vc = PopularViewController(reactor: reactor)
                vc.tabBarItem = tab.tabBarItem
                return vc
                
            case .favorite:
                let favoriteImageRepository = DefaultFavoriteImageRepository(storageManager: storageManager)
                let favoriteImageUseCase = DefaultFavoriteImageUseCase(favoriteImageRepository: favoriteImageRepository)
                let reactor = FavoriteViewReactor(favoriteImageUseCase: favoriteImageUseCase)
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
