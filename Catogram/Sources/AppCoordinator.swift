//
//  AppCoordinator.swift
//  Catogram
//
//  Created by Олег Крылов on 02/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
import UIKit
protocol Coordinatable {
    
}

final class AppCoordinator: Coordinatable {
    
    private let window: UIWindow
     lazy var tabBarController = UITabBarController()
    private lazy var navigationControllers = AppCoordinator.makeNavigationControllers()
    
    init(window: UIWindow) {
        self.window = window
        self.setupAppearance()
    }
    
    func start() {
            setupLogin()
    }
    
    func setupTabBar() {
        setupTabBarController()
    }
}

private extension AppCoordinator {
    func setupLogin() {
        let presenter = LoginPresenter()
        let viewController = LoginViewController(presenter: presenter)
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
    func setupTabBarController() {
        self.setupFeed()
        self.setupBreeds()
        self.setupSearch()
        self.setupFavourites()
        self.setupUpload()
        let navigationControllers = NavControllerType.allCases.compactMap {
            self.navigationControllers[$0]
        }
        self.tabBarController.setViewControllers(navigationControllers, animated: true)
        self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
    }
    
    func setupFeed() {
        guard let navController = self.navigationControllers[.feed] else {
            fatalError("can't find navController")
        }
        let presenter = FeedPresenter()
        let viewController = FeedViewController(presenter: presenter)
        viewController.view.backgroundColor = .white
        navController.setViewControllers([viewController], animated: false)
        viewController.navigationItem.title = NavControllerType.feed.title
    }
    
    func setupBreeds() {
        guard let navController = self.navigationControllers[.breeds] else {
            fatalError("can't find navController")
        }
        let presenter = BreedsPresenter()
        let viewController = BreedsViewController(presenter: presenter)
        viewController.view.backgroundColor = .white
        navController.setViewControllers([viewController], animated: false)
        viewController.navigationItem.title = NavControllerType.breeds.title
    }
    
    func setupSearch() {
        guard let navController = self.navigationControllers[.search] else {
            fatalError("can't find navController")
        }
        let presenter = SearchPresenter()
        let viewController = SearchViewController(presenter: presenter)
        viewController.view.backgroundColor = .white
        navController.setViewControllers([viewController], animated: false)
        viewController.navigationItem.title = NavControllerType.search.title
    }
    
    func setupFavourites() {
        guard let navController = self.navigationControllers[.favourites] else {
            fatalError("can't find navController")
        }
        let presenter = FavouritesPresenter()
        let viewController = FavouritesViewController(presenter: presenter)
        viewController.view.backgroundColor = .white
        navController.setViewControllers([viewController], animated: false)
        viewController.navigationItem.title = NavControllerType.favourites.title
    }
    
    func setupUpload() {
        guard let navController = self.navigationControllers[.upload] else {
            fatalError("can't find navController")
        }
        let presenter = UploadPresenter()
        let viewController = UploadViewController(presenter: presenter)
        viewController.view.backgroundColor = .white
        navController.setViewControllers([viewController], animated: false)
        viewController.navigationItem.title = NavControllerType.upload.title
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor.mainColor()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().isTranslucent = false
        //UINavigationBar.appearance().shadowImage = UIImage()
        
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = UIColor.mainColor()
    }
    
    static func makeNavigationControllers() -> [NavControllerType: UINavigationController] {
        var result: [NavControllerType: UINavigationController] = [:]
        NavControllerType.allCases.forEach { navControllerKey in
            let navigationController = UINavigationController()
            let tabBarItem = UITabBarItem(title: navControllerKey.title,
                                          image: navControllerKey.image,
                                          tag: navControllerKey.rawValue)
            navigationController.tabBarItem = tabBarItem
            navigationController.navigationBar.prefersLargeTitles = true
            result[navControllerKey] = navigationController
        }
        return result
    }
}

fileprivate enum NavControllerType: Int, CaseIterable {
    case feed, breeds, search, favourites, upload
    
    var title: String {
        switch self {
        case .feed:
            return Localization.feed
        case .breeds:
            return Localization.breeds
        case .search:
            return Localization.search
        case .favourites:
            return Localization.favourites
        case .upload:
            return Localization.upload
        }
    }
    
    var image: UIImage? {
        switch self {
        case .feed:
            return AppImages.feed
        case .breeds:
            return AppImages.breeds
        case .search:
            return AppImages.search
        case .favourites:
            return AppImages.favourites
        case .upload:
            return AppImages.upload
        }
    }
}
