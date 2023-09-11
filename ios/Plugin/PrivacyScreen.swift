import Foundation
import WebKit
import UIKit

@objc public class PrivacyScreen: NSObject {
    private let plugin: PrivacyScreenPlugin
    private let config: PrivacyScreenConfig

    private var isEnabled = true
    private var privacyViewController: UIViewController?

    init(plugin: PrivacyScreenPlugin, config: PrivacyScreenConfig) {
        self.plugin = plugin
        self.config = config

        self.privacyViewController = UIViewController()
        if self.config.imageName == "" || self.config.imageName == nil {
            self.privacyViewController!.view.backgroundColor = UIColor.gray
        } else {
            self.privacyViewController!.view.backgroundColor = UIColor.systemBackground
            var imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: self.privacyViewController!.view.bounds.width, height: self.privacyViewController!.view.bounds.height)
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            let imageBackground = UIImage(named: self.config.imageName)
            imageView.image = imageBackground
            self.privacyViewController!.view.addSubview(imageView)
        }
        self.privacyViewController!.modalPresentationStyle = UIModalPresentationStyle.overFullScreen

        super.init()
        if config.enable {
            self.enable(completion: nil)
        }
    }

    @objc public func enable(completion: (() -> Void)?) {
        self.isEnabled = true
        DispatchQueue.main.async {
            self.plugin.bridge?.webView?.disableScreenshots(self.config.imageName)
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
            self.plugin.bridge?.viewController?.present(self.privacyViewController!, animated: false, completion: nil)
        }
    }

    @objc public func handleDidBecomeActiveNotification() {
        DispatchQueue.main.async {
            self.privacyViewController?.dismiss(animated: false, completion: nil)
        }
    }

    @objc public func handleDidChangeStatusBarOrientationNotification() {
        self.plugin.bridge?.webView?.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

public extension WKWebView {
    func disableScreenshots(_ imageName: String = "") {
        addSecureText(imageName)
        addSecureText(imageName)
    }

    func addSecureText(_ imageName: String = "") {
        let field = UITextField()
        field.isSecureTextEntry = true
        if imageName != "" {
            let imageBackground = UIImage(named: imageName)
            field.backgroundColor = UIColor.systemBackground

            var backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.systemBackground
            backgroundView.frame = self.bounds
            field.addSubview(backgroundView)

            var imageView = UIImageView()
            imageView.frame = self.bounds
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            imageView.image = imageBackground
            field.addSubview(imageView)
        }
        field.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(field)
        field.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.first?.addSublayer(self.layer)
    }

    func enableScreenshots() {
        for view in self.subviews {
            if let textField = view as? UITextField {
                textField.isSecureTextEntry = false
            }
        }
    }
}
