//
//  AppDelegate.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit

import PresentationModule
import DomainModule
import DataModule
import NetworkModule
import DatabaseModule
import InjectionManager
import ThirdPartyManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureDIContainer()
        
        initializeWindow()
        
        start()
        
        return true
    }
    
    private func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
    
    private func start() {
        window?.rootViewController = LaunchViewController()
    }
}

// MARK: Configure DIContainer

extension AppDelegate {
    private func configureDIContainer() {
        // APINetworkConfig
        DIContainer.register(NetworkConfigurable.self) { resolver in
            let apiConfig = APINetworkConfig(
                baseURL: AppConfiguration.apiBaseURL,
                headers: [
                    HTTPHeaderKey.authorization.rawValue: AppConfiguration.apiKey
                ]
            )
            return apiConfig
        }
        
        // NetworkManager
        DIContainer.register(NetworkManagerType.self) { resolver in
            guard let apiConfig = resolver.resolve(NetworkConfigurable.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return NetworkManager(
                config: apiConfig
            )
        }
        
        // StorageManager
        DIContainer.register(StorageManagerType.self) { resolver in
            return StorageManager()
        }
        
        // SearchImageRepository
        DIContainer.register(SearchImageRepository.self) { resolver in
            guard let networkManager = resolver.resolve(NetworkManagerType.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return DefaultSearchImageRepository(
                networkManager: networkManager
            )
        }
        
        // FetchPopularImageRepository
        DIContainer.register(FetchPopularImageRepository.self) { resolver in
            guard let networkManager = resolver.resolve(NetworkManagerType.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return DefaultFetchPopularImageRepository(
                networkManager: networkManager
            )
        }
        
        // FavoriteImageRepository
        DIContainer.register(FavoriteImageRepository.self) { resolver in
            guard let storageManager = resolver.resolve(StorageManagerType.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return DefaultFavoriteImageRepository(
                storageManager: storageManager
            )
        }
        
        // SearchImageUseCase
        DIContainer.register(SearchImageUseCase.self) { resolver in
            guard let searchImageRepo = resolver.resolve(SearchImageRepository.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return DefaultSearchImageUseCase(
                searchImageRepository: searchImageRepo
            )
        }
        
        // FetchPopularImageUseCase
        DIContainer.register(FetchPopularImageUseCase.self) { resolver in
            guard let fetchPopularImageRepo = resolver.resolve(FetchPopularImageRepository.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return DefaultFetchPopularImageUseCase(
                fetchPopularImageRepository: fetchPopularImageRepo
            )
        }
        
        // FavoriteImageUseCase
        DIContainer.register(FavoriteImageUseCase.self) { resolver in
            guard let favoriteImageRepo = resolver.resolve(FavoriteImageRepository.self)
            else { fatalError("Dependency Injection Configuration Failed.") }
            return DefaultFavoriteImageUseCase(
                favoriteImageRepository: favoriteImageRepo
            )
        }
    }
}
