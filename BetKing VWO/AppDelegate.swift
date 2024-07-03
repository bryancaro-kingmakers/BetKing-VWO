//
//  AppDelegate.swift
//  BetKing VWO
//
//  Created by Bryan Caro on 2/7/24.
//

import UIKit
import VWO_Insights

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var rootCoordinator: BaseCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        VWOConfigure()
        
        let builder = ContainerBuilder {
            RealSplashScreenStageContainer()
        }
        
        rootCoordinator = RootCoordinator(containerBuilder: builder)
        rootCoordinator?.start()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    private func VWOConfigure() {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let userId = deviceId
        
        VWO.configure(
            accountId: "742951",
            appId: "3f1e4143c30b9be6c50667f91b8de813",
            userId: userId
        ) {  result in
            switch result {
            case .success(let response):
                print("VWO Success: ", response)
                VWO.startSessionRecording()
            case .failure(let error):
                print("VWO Error: ", error)
            }
        }
    }
}

