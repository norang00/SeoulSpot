//
//  AppCoordinator.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var navigationController: UINavigationController
    
    private var tabBarController: UITabBarController!
    private var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        makeTabBar()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func makeTabBar() {
        tabBarController = UITabBarController()
        
        //큐레이션 탭
        let curationNav = UINavigationController()
        let curationCoordinator = CurationCoordinator(navigationController: curationNav)
        childCoordinators.append(curationCoordinator)
        curationCoordinator.start()
        curationNav.tabBarItem = UITabBarItem(title: Resources.curation.title,
                                              image: Resources.curation.icon, tag: 0)
        
        //지도 탭
        let searchMapNav = UINavigationController()
        let searchMapCoordinator = SearchMapCoordinator(navigationController: searchMapNav)
        childCoordinators.append(searchMapCoordinator)
        searchMapCoordinator.start()
        searchMapNav.tabBarItem = UITabBarItem(title: Resources.searchMap.title,
                                               image: Resources.searchMap.icon, tag: 1)
        
        //저장 탭
        let pinnedNav = UINavigationController()
        let pinnedCoordinator = PinnedCoordinator(navigationController: pinnedNav)
        childCoordinators.append(pinnedCoordinator)
        pinnedCoordinator.start()
        pinnedNav.tabBarItem = UITabBarItem(title: Resources.pinned.title,
                                            image: Resources.pinned.icon, tag: 2)
        
        //탭바 구성
        tabBarController.viewControllers = [curationNav, searchMapNav, pinnedNav]
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.tintColor = .accent
        tabBarController.tabBar.backgroundColor = .white
    }
}
