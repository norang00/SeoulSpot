//
//  SceneDelegate.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        initData { [weak self] in
            let appCoordinator = AppCoordinator(window: self?.window)
            appCoordinator.start()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.shared.saveContext()
    }
}

// MARK: -Fetch Data at App Launch
extension SceneDelegate {
    
    func initData(completionHandler: @escaping () -> Void) {
        if AppDataTracker.shared.shouldRefreshEventData() {
            NetworkManager.shared.callRequestToAPIServer(.culturalEvents(option: .init(startIndex: 1, endIndex: 300)), CulturalEventResponse.self) { result in
                switch result {
                case .success(let success):
                    let events = success.culturalEventInfo.row
                    CoreDataManager.shared.deleteAllEvents()
                    CoreDataManager.shared.saveEventBatch(events)
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                case .failure(let failure):
                    print("failed to init data", failure.localizedDescription)
                }
            }
        } else {
            print("use saved data in CoreData")
            completionHandler()
        }
    }
}
