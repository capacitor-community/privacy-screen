import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrivacyScreenPlugin)
public class PrivacyScreenPlugin: CAPPlugin {
    private var isEnabled = true
    private var privacyViewController: UIViewController?

    self.privacyViewController = UIViewController()
    self.privacyViewController!.view.backgroundColor = UIColor.gray
    self.privacyViewController!.modalPresentationStyle = UIModalPresentationStyle.overFullScreen

    override public func load() {
        self.isEnabled = privacyScreenConfig().enable
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDetectCapturing),
                                               name: UIScreen.capturedDidChangeNotification, object: nil)
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

    @objc func show(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            if self.privacyViewController?.presentingViewController == nil {
                self.bridge?.viewController?.present(self.privacyViewController!, animated: false, completion: nil)
            }
            call.resolve()
        }
    }

    @objc func hide(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            if self.privacyViewController?.presentingViewController != nil {
                self.privacyViewController?.dismiss(animated: false, completion: nil)
            }
            call.resolve()
        }
    }

    @objc func onAppWillResignActive() {
        guard self.isEnabled else {
            return
        }

        DispatchQueue.main.async {
            if self.privacyViewController?.presentingViewController == nil {
                self.bridge?.viewController?.present(self.privacyViewController!, animated: false, completion: nil)
            }
        }
    }

    @objc func onAppDidBecomeActive() {
        guard self.isEnabled else {
            return
        }

        DispatchQueue.main.async {
            if self.privacyViewController?.presentingViewController != nil {
                if #available(iOS 11.0, *) {
                    guard !UIScreen.main.isCaptured else {
                        return
                    }
                    self.privacyViewController?.dismiss(animated: false, completion: nil)
                } else{
                    self.privacyViewController?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }

    @objc private func onAppDetectCapturing() {
        guard self.isEnabled else {
            return
        }

        if #available(iOS 11.0, *) {
            self.notifyListeners("capturingDetected", data: ["capturing": UIScreen.main.isCaptured])
        }

    }

    private func privacyScreenConfig() -> PrivacyScreenConfig {
        var config = PrivacyScreenConfig()
        config.enable = getConfig().getBoolean("enable", config.enable)
        return config
    }
}
