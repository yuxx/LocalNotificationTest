import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            NSLog("\(String(describing: Self.self))::\(#function)@\(#line) window is nil.")
            return false
        }
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
    }
}
