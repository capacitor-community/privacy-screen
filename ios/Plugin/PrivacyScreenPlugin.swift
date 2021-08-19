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
    private var alert: UIAlertController?

    override public func load() {
        self.isEnabled = privacyScreenConfig().enable
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDetectRecording),
                                               name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDetectScreenshot),
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

        self.privacyViewController = UIViewController()
        self.privacyViewController!.view.backgroundColor = .clear;
        self.privacyViewController!.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        if !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.privacyViewController!.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.privacyViewController!.view.addSubview(blurEffectView)
        } else {
            self.privacyViewController!.view.backgroundColor = .gray
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

    private func privacyScreenConfig() -> PrivacyScreenConfig {
        var config = PrivacyScreenConfig()

        if let enable = getConfigValue("enable") as? Bool {
            config.enable = enable
        }
        return config
    }

    @objc private func didDetectRecording() {
        guard self.isEnabled else {
            return
        }

        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                DispatchQueue.main.async {
                    self.bridge?.viewController?.present(self.privacyViewController!, animated: false, completion: nil)
                }
            } else {
                self.privacyViewController?.dismiss(animated: false, completion: nil)
            }
        }

    }

    @objc private func didDetectScreenshot() {
        guard self.isEnabled else {
            return
        }

        self.alert = UIAlertController(title: "Attention",
                                      message: "Screenshots may contain sensitive data. Do not keep them on your phone!",
                                      preferredStyle: .alert)
        self.alert?.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.bridge?.viewController?.present(self.alert!, animated: false, completion: nil)
        }
    }
}
