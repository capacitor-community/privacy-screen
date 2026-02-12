import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrivacyScreenPlugin)
public class PrivacyScreenPlugin: CAPPlugin {
    private var implementation: PrivacyScreen?

    override public func load() {
        let config = getPrivacyScreenConfig()
        self.implementation = PrivacyScreen(plugin: self, config: config, window: UIApplication.shared.delegate?.window as? UIWindow)
        
        if(config.foregroundBackgroundEvent ?? false) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleWillEnterForegroundNotification),
                                                   name: UIScene.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidEnterBackgroundNotification),
                                                   name: UIScene.didEnterBackgroundNotification, object: nil)

        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidBecomeActiveNotification),
                                                   name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleWillResignActiveNotification),
                                                   name: UIApplication.willResignActiveNotification, object: nil)
        }

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleCapturedDidChangeNotification),
                                               name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserDidTakeScreenshotNotification),
                                               name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidChangeStatusBarOrientationNotification),
                                               name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func enable(_ call: CAPPluginCall) {
        implementation?.enable(completion: {
            call.resolve()
        })
    }

    @objc func disable(_ call: CAPPluginCall) {
        implementation?.disable(completion: {
            call.resolve()
        })
    }
    
    @objc private func handleDidBecomeActiveNotification() {
        implementation?.hidePrivacyController()
    }
    
    @objc private func handleWillResignActiveNotification() {
        implementation?.showPrivacyController()
    }

    @objc private func handleWillEnterForegroundNotification() {
        implementation?.hidePrivacyController()
    }
    @objc private func handleDidEnterBackgroundNotification() {
        implementation?.showPrivacyController()
    }

    @objc private func handleCapturedDidChangeNotification() {
        if UIScreen.main.isCaptured {
            self.notifyListeners("screenRecordingStarted", data: nil)
        } else {
            self.notifyListeners("screenRecordingStopped", data: nil)
        }
    }

    @objc private func handleUserDidTakeScreenshotNotification() {
        self.notifyListeners("screenshotTaken", data: nil)
    }

    @objc private func handleDidChangeStatusBarOrientationNotification() {
        implementation?.handleDidChangeStatusBarOrientationNotification()
    }

    private func getPrivacyScreenConfig() -> PrivacyScreenConfig {
        var config = PrivacyScreenConfig()
        config.enable = getConfig().getBoolean("enable", config.enable)
        config.imageName = getConfig().getString("imageName", config.imageName)
        config.contentMode = getConfig().getString("contentMode", config.contentMode)
        config.preventScreenshots = getConfig().getBoolean("preventScreenshots", true)
        config.foregroundBackgroundEvent = getConfig().getBoolean("foregroundBackgroundEvent", false)
        return config
    }
}