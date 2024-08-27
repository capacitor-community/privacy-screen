import Foundation
import WebKit
import UIKit

@objc public class PrivacyScreen: NSObject {
    private let plugin: PrivacyScreenPlugin
    private let config: PrivacyScreenConfig
    private let privacyViewController: UIViewController
    private var isEnabled = false
    private var window: UIWindow?
    private var screenPrevent = UITextField()

    init(plugin: PrivacyScreenPlugin, config: PrivacyScreenConfig, window: UIWindow?) {
        self.plugin = plugin
        self.config = config
        self.privacyViewController = PrivacyScreen.createPrivacyViewController(config: config)

        super.init()
        if config.enable {
            self.enable(completion: nil)
        }

        self.window = window
        let preventScreenshots = config.preventScreenshots ?? true
        if preventScreenshots {
            configurePreventionScreenshot()
        }
    }

    public func configurePreventionScreenshot() {
        guard let mainWindow = window else { return }

        if !mainWindow.subviews.contains(screenPrevent) {
            mainWindow.addSubview(screenPrevent)
            screenPrevent.centerYAnchor.constraint(equalTo: mainWindow.centerYAnchor).isActive = true
            screenPrevent.centerXAnchor.constraint(equalTo: mainWindow.centerXAnchor).isActive = true
            mainWindow.layer.superlayer?.addSublayer(screenPrevent.layer)
            if #available(iOS 17.0, *) {
                screenPrevent.layer.sublayers?.last?.addSublayer(mainWindow.layer)
            } else {
                screenPrevent.layer.sublayers?.first?.addSublayer(mainWindow.layer)
            }
        }
    }

    @objc public func enable(completion: (() -> Void)?) {
        self.isEnabled = true
        DispatchQueue.main.async {
            self.plugin.bridge?.webView?.disableScreenshots(imageName: self.config.imageName, screenPrevent: self.screenPrevent)
            completion?()
        }
    }

    @objc public func disable(completion: (() -> Void)?) {
        self.isEnabled = false
        DispatchQueue.main.async {
            self.plugin.bridge?.webView?.enableScreenshots(screenPrevent: self.screenPrevent)
            completion?()
        }
    }

    @objc public func handleWillResignActiveNotification() {
        guard self.isEnabled else {
            return
        }
        DispatchQueue.main.async {
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive || $0.activationState == .foregroundInactive})
                .compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
            if var rootVC = window?.rootViewController, !self.privacyViewController.isBeingPresented {
                while let topVC = rootVC.presentedViewController {
                    rootVC = topVC
                }
                if rootVC.presentedViewController != self.privacyViewController && !self.privacyViewController.isBeingPresented && !self.privacyViewController.isBeingDismissed {
                    rootVC.present(self.privacyViewController, animated: false, completion: nil)
                }
            } else {
                if self.plugin.bridge?.viewController?.presentedViewController != self.privacyViewController {
                    self.plugin.bridge?.viewController?.present(self.privacyViewController, animated: false, completion: nil)
                }
            }
        }
    }

    @objc public func handleDidBecomeActiveNotification() {
        DispatchQueue.main.async {
            self.privacyViewController.dismiss(animated: false, completion: nil)
        }
    }

    @objc public func handleDidChangeStatusBarOrientationNotification() {
        self.plugin.bridge?.webView?.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    private static func createPrivacyViewController(config: PrivacyScreenConfig) -> UIViewController {
        let privacyViewController = UIViewController()
        if let imageName = config.imageName, !imageName.isEmpty {
            privacyViewController.view.backgroundColor = UIColor.systemBackground

            let contentMode = getContentModeFromString(config.contentMode) ?? .center
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: privacyViewController.view.bounds.width, height: privacyViewController.view.bounds.height)
            imageView.contentMode = contentMode
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: imageName)
            privacyViewController.view.addSubview(imageView)
        } else {
            privacyViewController.view.backgroundColor = UIColor.gray
        }
        privacyViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        return privacyViewController
    }

    private static func getContentModeFromString(_ contentMode: String?) -> UIView.ContentMode? {
        switch contentMode?.lowercased() {
        case "center": return .center
        case "scaleaspectfill": return .scaleAspectFill
        case "scaleaspectfit": return .scaleAspectFit
        case "scaletofill": return .scaleToFill
        default: return nil
        }
    }
}

public extension WKWebView {

    func enableScreenshots(screenPrevent: UITextField) {
        screenPrevent.isSecureTextEntry = false
    }

    func disableScreenshots(imageName: String?, screenPrevent: UITextField) {
        screenPrevent.isSecureTextEntry = true
    }
}
