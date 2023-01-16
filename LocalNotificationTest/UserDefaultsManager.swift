import Foundation

final class UserDefaultsManager {
    static let instance = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard

    enum Keys: String {
        case phoneNumber
            , notificationSec
    }
    private init() {}
    func setUserDefaults<T>(_ newValue: T?, keyName: String) {
        guard let newValue = newValue else {
            userDefaults.removeObject(forKey: keyName)
            return
        }
        userDefaults.set(newValue, forKey: keyName)
    }

    var phoneNumber: String? {
        set {
            setUserDefaults(newValue, keyName: Keys.phoneNumber.rawValue)
        }
        get {
            userDefaults.string(forKey: Keys.phoneNumber.rawValue)
        }
    }

    var notificationSec: String? {
        set {
            setUserDefaults(newValue, keyName: Keys.notificationSec.rawValue)
        }
        get {
            userDefaults.string(forKey: Keys.notificationSec.rawValue)
        }
    }
}
