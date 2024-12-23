//
//  WebViewManager.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//


import SafariServices
import Combine

protocol AppliveryWebViewManagerProtocol {
    func showWebView(url: URL)
    var tokenPublisher: AnyPublisher<String?, Never> { get }
}

final class AppliveryWebViewManager: NSObject, AppliveryWebViewManagerProtocol {
    
    static public let shared = AppliveryWebViewManager()
    
    private weak var safariViewController: SFSafariViewController?
    private var window: UIWindow?
    
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    var tokenPublisher: AnyPublisher<String?, Never> {
        return tokenSubject.eraseToAnyPublisher()
    }
    
    private override init() {}
    
    func showWebView(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        setNewWindow(viewController: safariVC)
        log("Showing web view in a new window")
        self.safariViewController = safariVC
    }
    
    func urlReceived(url: URL) {
        if let token = getTokenfromURL(url: url) {
            removeWindow()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tokenSubject.send(token)
            }
        }
    }
}

extension AppliveryWebViewManager: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        tokenSubject.send(nil)
        removeWindow()
    }
}

private extension AppliveryWebViewManager {
    func getTokenfromURL(url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let bearer = components.queryItems?.first(where: { $0.name == "bearer" })?.value {
            return bearer
        }
        return nil
    }
    
    func setNewWindow(viewController: UIViewController) {
        let hostingViewController = UIViewController()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = hostingViewController
        newWindow.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        newWindow.makeKeyAndVisible()
        hostingViewController.present(viewController, animated: true)
        
        self.window = newWindow
    }
    
    func removeWindow() {
        safariViewController?.dismiss(animated: true, completion: nil)
        safariViewController = nil
        window?.isHidden = true
        window = nil
    }
}
