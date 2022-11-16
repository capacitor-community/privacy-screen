import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrivacyScreenPlugin)
public class PrivacyScreenPlugin: CAPPlugin {
    private var isEnabled = true
    private var backgroundColor = UIColor.gray
    private var privacyViewController: UIViewController?

    override public func load() {
        self.isEnabled = privacyScreenConfig().enable
        self.backgroundColor = privacyScreenConfig().backgroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func enable(_ call: CAPPluginCall) {
        self.isEnabled = true
        call.resolve()
    }

    @objc func disable(_ call: CAPPluginCall) {
        self.isEnabled = false
        call.resolve()
    }

    @objc func onAppWillResignActive() {
        guard self.isEnabled else {
            return
        }
        self.privacyViewController = UIViewController()
        self.privacyViewController!.view.backgroundColor = self.backgroundColor
        self.privacyViewController!.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        DispatchQueue.main.async {
            self.bridge?.viewController?.present(self.privacyViewController!, animated: false, completion: nil)
        }
    }

    @objc func onAppDidBecomeActive() {
        DispatchQueue.main.async {
            self.privacyViewController?.dismiss(animated: false, completion: nil)
        }
    }

    private func privacyScreenConfig() -> PrivacyScreenConfig {
        var config = PrivacyScreenConfig()

        if let enable = getConfigValue("enable") as? Bool {
            config.enable = enable
        }

        if let backgroundColorHex = getConfigValue("ios.backgroundColorHex8") as? String {
            config.backgroundColor = UIColor(hex: backgroundColorHex)
        }

        return config
    }
}

extension UIColor {
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        self.init(red: 0, green: 0, blue: 0, alpha: 1)
        return
    }
}
