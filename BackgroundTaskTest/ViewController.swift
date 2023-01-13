import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            let nc = UNUserNotificationCenter.current()
            nc.requestAuthorization(options: authOptions) {(isPermitted, error) in
                if let error = error {
                    NSLog(String(describing: error))
                    return
                }
                NSLog("isPermitted: \(isPermitted)")
            }
        }
        setupSubviews()
    }

    private let centerArea = UIView()
    private let setNotificationButton = UIButton()
    private let notificationSecToolBar = UIToolbar()
    private let notificationSecField = UITextField()
    private let notificationSecLabel = UILabel()
    private let phoneNumberToolBar = UIToolbar()
    private let phoneNumberField = UITextField()
    private let startCallingWithLocalPushButton = UIButton()
    private func setupSubviews() {
        view.addSubview(centerArea)
        centerArea.addSubview(setNotificationButton)
        centerArea.addSubview(notificationSecField)
        centerArea.addSubview(notificationSecLabel)
        centerArea.addSubview(phoneNumberField)
        centerArea.addSubview(startCallingWithLocalPushButton)

        setupAppearance()
        setupButtonActions()
        setupConstraints()
    }

    private func setupAppearance() {
        view.backgroundColor = .white

        setNotificationButton.setTitle("通知だけセットする", for: .normal)
        setNotificationButton.setTitleColor(.black, for: .normal)
        setNotificationButton.backgroundColor = .green
        setNotificationButton.layer.cornerRadius = 10
        setNotificationButton.clipsToBounds = true
        setNotificationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        notificationSecField.text = UserDefaultsManager.instance.notificationSec ?? "60"
        notificationSecField.placeholder = "通知秒数"
        notificationSecField.layer.cornerRadius = 5
        notificationSecField.clipsToBounds = true
        notificationSecField.keyboardType = .numberPad
        notificationSecField.inputAccessoryView = notificationSecToolBar
        notificationSecToolBar.sizeToFit()
        notificationSecField.textAlignment = .right
        let rightPadding = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
        notificationSecField.rightView = rightPadding
        notificationSecField.rightViewMode = .always
        notificationSecField.layer.borderColor = UIColor.black.cgColor
        notificationSecField.layer.borderWidth = 1

        notificationSecLabel.text = "秒"

        phoneNumberField.text = UserDefaultsManager.instance.phoneNumber
        phoneNumberField.placeholder = "電話番号"
        phoneNumberField.layer.cornerRadius = 5
        phoneNumberField.clipsToBounds = true
        phoneNumberField.keyboardType = .numberPad
        phoneNumberField.inputAccessoryView = phoneNumberToolBar
        phoneNumberToolBar.sizeToFit()
        let leftPadding = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 0)))
        phoneNumberField.leftView = leftPadding
        phoneNumberField.leftViewMode = .always
        phoneNumberField.layer.borderColor = UIColor.black.cgColor
        phoneNumberField.layer.borderWidth = 1

        startCallingWithLocalPushButton.setTitle("通話開始(LocalPush版)", for: .normal)
        startCallingWithLocalPushButton.setTitleColor(.white, for: .normal)
        startCallingWithLocalPushButton.backgroundColor = .red
        startCallingWithLocalPushButton.layer.cornerRadius = 10
        startCallingWithLocalPushButton.clipsToBounds = true
        startCallingWithLocalPushButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    private func setupConstraints() {
        centerArea.translatesAutoresizingMaskIntoConstraints = false
        setNotificationButton.translatesAutoresizingMaskIntoConstraints = false
        notificationSecField.translatesAutoresizingMaskIntoConstraints = false
        notificationSecLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberField.translatesAutoresizingMaskIntoConstraints = false
        startCallingWithLocalPushButton.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            centerArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerArea.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // NOTE: width がサブビューと制約紐付けが無いためこの設定がないと0px扱いになってボタンも反応しなくなる
            centerArea.widthAnchor.constraint(equalTo: view.widthAnchor),

            setNotificationButton.topAnchor.constraint(equalTo: centerArea.topAnchor),
            setNotificationButton.centerXAnchor.constraint(equalTo: centerArea.centerXAnchor),
            setNotificationButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),

            notificationSecField.topAnchor.constraint(equalTo: setNotificationButton.bottomAnchor, constant: 10),
            notificationSecField.widthAnchor.constraint(equalToConstant: 100),
            notificationSecField.heightAnchor.constraint(equalToConstant: 30),
            notificationSecField.centerXAnchor.constraint(equalTo: centerArea.centerXAnchor),

            notificationSecLabel.leftAnchor.constraint(equalTo: notificationSecField.rightAnchor, constant: 5),
            notificationSecLabel.centerYAnchor.constraint(equalTo: notificationSecField.centerYAnchor),

            phoneNumberField.topAnchor.constraint(equalTo: notificationSecField.bottomAnchor, constant: 10),
            phoneNumberField.widthAnchor.constraint(equalToConstant: 200),
            phoneNumberField.heightAnchor.constraint(equalToConstant: 30),
            phoneNumberField.centerXAnchor.constraint(equalTo: centerArea.centerXAnchor),

            startCallingWithLocalPushButton.topAnchor.constraint(equalTo: phoneNumberField.bottomAnchor, constant: 10),
            startCallingWithLocalPushButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
            startCallingWithLocalPushButton.heightAnchor.constraint(equalToConstant: 40),
            startCallingWithLocalPushButton.centerXAnchor.constraint(equalTo: centerArea.centerXAnchor),
            startCallingWithLocalPushButton.bottomAnchor.constraint(equalTo: centerArea.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupButtonActions() {
        setNotificationButton.addTarget(NotificationManager.instance, action: #selector(NotificationManager.setLocalNotificationTimer), for: .touchUpInside)

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let cancelEditingNotificationSec = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeNotificationSecInput))
        let finishEditingNotificationSec = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(finishEditingNotificationSec))
        notificationSecToolBar.items = [cancelEditingNotificationSec, spacer, finishEditingNotificationSec]

        let cancelEditingPhoneNumber = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closePhoneNumberInput))
        let finishEditingPhoneNumber = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(finishEditingPhoneNumber))
        phoneNumberToolBar.items = [cancelEditingPhoneNumber, spacer, finishEditingPhoneNumber]

        startCallingWithLocalPushButton.addTarget(self, action: #selector(startCallingWithLocalPush), for: .touchUpInside)
    }

    @objc private func closeNotificationSecInput() {
        notificationSecField.text = UserDefaultsManager.instance.notificationSec ?? String(NotificationManager.defaultIntervalSec)
        notificationSecField.resignFirstResponder()
    }

    @objc private func closePhoneNumberInput() {
        phoneNumberField.text = UserDefaultsManager.instance.phoneNumber
        phoneNumberField.resignFirstResponder()
    }

    @objc private func finishEditingNotificationSec() {
        UserDefaultsManager.instance.notificationSec = notificationSecField.text
        closeNotificationSecInput()
    }

    @objc private func finishEditingPhoneNumber() {
        UserDefaultsManager.instance.phoneNumber = phoneNumberField.text
        closePhoneNumberInput()
    }

    @objc private func startCallingWithLocalPush() {
        guard let phoneNumberText = UserDefaultsManager.instance.phoneNumber else {
            NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
            return
        }
        guard let phoneURL = URL(string: "tel://" + phoneNumberText) else {
            NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
            return
        }
        UIApplication.shared.open(phoneURL) { isSucceeded in
            guard isSucceeded else {
                NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
                return
            }
            NotificationManager.instance.enqueueLocalNotification()
            CallManager.instance.startObserve()
            NSLog("\(String(describing: Self.self))::\(#function)@\(#line)")
        }
    }
}
