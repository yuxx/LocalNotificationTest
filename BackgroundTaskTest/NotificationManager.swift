import UserNotifications

final class NotificationManager: NSObject {
    static let instance = NotificationManager()

    private override init() {
        super.init()
        let userNotification = UNUserNotificationCenter.current()
        userNotification.delegate = self
    }

    private var isQueued = false

    @objc func enqueueLocalNotification() {
        isQueued = true
    }

    static let defaultIntervalSec = 60
    static let notificationIdentifier = "local-notification"

    @objc func setLocalNotificationTimer() {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        isQueued = false
        let content = UNMutableNotificationContent()
        content.title = "たいとる"
        content.body = "ボデー"
        content.sound = UNNotificationSound.default
        let notificationSec: Int = {
            guard let notificationSecString = UserDefaultsManager.instance.notificationSec
                , let notificationSec = Int(notificationSecString)
            else {
                return Self.defaultIntervalSec
            }
            return notificationSec
        }()
        // Note: repeats: true の場合はインターバルを60秒以上にしないといけない
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(notificationSec), repeats: false)
        let request = UNNotificationRequest(identifier: Self.notificationIdentifier, content: content, trigger: trigger)
        let nc = UNUserNotificationCenter.current()
        nc.add(request)
    }

    func purgeLocalNotification() {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Self.notificationIdentifier])
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> ()) {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)"
            + "\nresponse.notification.request.trigger: \(response.notification.request.trigger)"
        )
        completionHandler()
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> ()) {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)"
            + "\nnotification.request.trigger: \(notification.request.trigger)"
        )
        completionHandler(.alert)
    }
}
