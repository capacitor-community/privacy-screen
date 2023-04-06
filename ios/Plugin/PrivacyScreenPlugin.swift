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

    override public func load() {
        self.isEnabled = privacyScreenConfig().enable
        self.privacyViewController = UIViewController()
        self.privacyViewController!.view.backgroundColor = UIColor.gray
        self.privacyViewController!.modalPresentationStyle = UIModalPresentationStyle.overFullScreen

        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDetectCapturing),
                                               name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDetectScreenshot),
                                               name: UIApplication.userDidTakeScreenshotNotification, object: nil)
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

        DispatchQueue.main.async {
            self.bridge?.viewController?.present(self.privacyViewController!, animated: false, completion: nil)
        }
    }

    @objc func onAppDidBecomeActive() {
        DispatchQueue.main.async {
            self.privacyViewController?.dismiss(animated: false, completion: nil)
        }
    }

    @objc private func onAppDetectCapturing() {
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                self.notifyListeners("screenRecordingStarted", data: nil)
            } else {
                self.notifyListeners("screenRecordingStopped", data: nil)
            }
        }
    }

    @objc private func onAppDetectScreenshot() {
        self.notifyListeners("screenshotTaken", data: nil)
    }

    private func privacyScreenConfig() -> PrivacyScreenConfig {
        var config = PrivacyScreenConfig()
        config.enable = getConfig().getBoolean("enable", config.enable)
        return config
    }
}
