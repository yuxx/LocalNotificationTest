import CallKit

final class CallManager: NSObject {
    static let instance = CallManager()

    private var observer: CXCallObserver?

    private(set) var hasConnected: Bool? = nil
    private(set) var hasEnded: Bool? = nil
    private(set) var isOnHold: Bool? = nil
    private(set) var isOutgoing: Bool? = nil

    private override init() {}

    func startObserve() {
        guard observer == nil else { return }
        observer = CXCallObserver()
        observer?.setDelegate(self, queue: nil)
    }

    func endObserve() {
        observer = nil
    }
}

extension CallManager: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line)"
            + "\nhasConnected: \(call.hasConnected)"
            + "\nhasEnded: \(call.hasEnded)"
            + "\nisOnHold: \(call.isOnHold)"
            + "\nisOutgoing: \(call.isOutgoing)"
        )
        hasConnected = call.hasConnected
        hasEnded = call.hasEnded
        isOnHold = call.isOnHold
        isOutgoing = call.isOutgoing
        guard call.hasEnded else {
            NSLog("\(String(describing: Self.self))::\(#function)@\(#line) Call is not terminated.")
            return
        }
        NSLog("\(String(describing: Self.self))::\(#function)@\(#line) Call has ended.")
        endObserve()
        NotificationManager.instance.purgeLocalNotification()
    }
}