import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrivacyScreen)
public class PrivacyScreen: CAPPlugin {
    override public func load() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onAppWillResignActive() {
        let privacyViewController = UIViewController()
        privacyViewController.view.backgroundColor = UIColor.gray;
        privacyViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        DispatchQueue.main.async {
            self.bridge.viewController.present(privacyViewController, animated: false, completion: nil)
        }
    }

    @objc func onAppDidBecomeActive() {
        DispatchQueue.main.async {
            self.bridge.viewController.dismiss(animated: false, completion: nil)
        }
    }
}
