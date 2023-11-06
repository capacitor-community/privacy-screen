import Foundation
import WebKit
import UIKit

@objc public class PrivacyScreen: NSObject {
    private let plugin: PrivacyScreenPlugin
    private let config: PrivacyScreenConfig
    private let privacyViewController: UIViewController

    private var isEnabled = false

    init(plugin: PrivacyScreenPlugin, config: PrivacyScreenConfig) {
        self.plugin = plugin
        self.config = config
        self.privacyViewController = PrivacyScreen.createPrivacyViewController(config: config)

        super.init()
        if config.enable {
            self.enable(completion: nil)
        }
    }

    @objc public func enable(completion: (() -> Void)?) {
        self.isEnabled = true
        DispatchQueue.main.async {
            self.plugin.bridge?.webView?.disableScreenshots(imageName: self.config.imageName)
            completion?()
        }
    }

    @objc public func disable(completion: (() -> Void)?) {
        self.isEnabled = false
        DispatchQueue.main.async {
            self.plugin.bridge?.webView?.enableScreenshots()
            completion?()
        }
    }

    @objc public func handleWillResignActiveNotification() {
        guard self.isEnabled else {
            return
        }
        DispatchQueue.main.async {
            self.plugin.bridge?.viewController?.present(self.privacyViewController, animated: false, completion: nil)
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
        if let imageName = config.imageName {
            privacyViewController.view.backgroundColor = UIColor.systemBackground

            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: privacyViewController.view.bounds.width, height: privacyViewController.view.bounds.height)
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: imageName)
            privacyViewController.view.addSubview(imageView)
        } else {
            privacyViewController.view.backgroundColor = UIColor.gray
        }
        privacyViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        return privacyViewController
    }
}

public extension WKWebView {
    // Cannot be tested in simulator
    func disableScreenshots(imageName: String?) {
        addSecureText(imageName)
        addSecureText(imageName)
    }

    func addSecureText(_ imageName: String?) {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(field)
        field.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.layer.superlayer?.addSublayer(field.layer)
        // Must be `last` for iOS 17, see https://github.com/capacitor-community/privacy-screen/issues/74
        field.layer.sublayers?.last?.addSublayer(self.layer)
    }

    func enableScreenshots() {
        for view in self.subviews {
            if let textField = view as? UITextField {
                textField.isSecureTextEntry = false
            }
        }
    }
}
