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
}

extension AppDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        let callManager = CallManager.instance
        // Note: オプショナルで定義しているので比較対象を明示
        if callManager.hasConnected == false && callManager.isOutgoing == true {
            NotificationManager.instance.setLocalNotificationTimer()
        }
    }
}
