# iOS Demo App with VWO Insights

This repository contains a demo iOS application that implements VWO Insights to track user session screens. The app is a web view, and there is an issue where the app crashes after 2-3 minutes of interaction without any traceable error in Xcode.

## Setup and Configuration

### Installation

1. Clone the repository:
    ```sh
    git clone <repository_url>
    ```

2. Navigate to the project directory:
    ```sh
    cd <project_directory>
    ```
    
3. Install the dependencies:
    ```sh
    pod install
    ```

4. Open the project in Xcode:
    ```sh
    open <project_name>.xcodeproj
    ```


### VWO Insights Configuration

The VWO Insights SDK is configured and session recording is started in the `AppDelegate.swift` file:

```swift
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
```


### Issue Description

The app crashes after 2-3 minutes of interaction such as scrolling, opening windows, etc., without providing any crash logs or error messages in XCode. The exact cause of the crash is unknown and needs to be investigated.

### Steps to Reproduce
1.  ```sh
     Run the app on an iOS device or simulator.
    ```

2. ```sh
    Interact with the web view by scrolling, opening windows, etc.
    ```
    
3. ```sh
    Observe that the app crashes after approximately 2-3 minutes.
    ```


### Current Findings
1.  ```sh
    No error messages or crash logs are reported in Xcode.
    ```

2. ```sh
    The crash occurs during user interaction within the web view.
    ```

### Video Demonstration

The app crashes after 6 minutes of interaction such as scrolling, opening windows, etc.

https://github.com/bryancaro-kingmakers/BetKing-VWO/assets/168810572/9a6c6420-8d65-4223-8b6d-848d85164d39


