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
        self.privacyViewController!.view.backgroundColor = UIColor.gray;
        self.privacyViewController!.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        DispatchQueue.main.async {
            self.bridge.viewController.present(self.privacyViewController!, animated: false, completion: nil)
        }
    }

    @objc func onAppDidBecomeActive() {
        DispatchQueue.main.async {
            self.privacyViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
