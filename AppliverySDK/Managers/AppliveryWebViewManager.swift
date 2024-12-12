//
//  WebViewManager.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//


import SafariServices
import Combine

protocol AppliveryWebViewManagerProtocol {
    func showWebView(url: URL, from viewController: UIViewController)
    func closeWebView()
    var tokenPublisher: AnyPublisher<String?, Never> { get }
}

final class AppliveryWebViewManager: NSObject, AppliveryWebViewManagerProtocol {
    
    static public let shared = AppliveryWebViewManager()
    
    private weak var safariViewController: SFSafariViewController?
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    var tokenPublisher: AnyPublisher<String?, Never> {
        return tokenSubject.eraseToAnyPublisher()
    }
    
    private override init() {}
    
    func showWebView(url: URL, from viewController: UIViewController) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        viewController.present(safariVC, animated: true, completion: nil)
        self.safariViewController = safariVC
    }
    
    func closeWebView() {
        safariViewController?.dismiss(animated: true, completion: nil)
        safariViewController = nil
    }
    
    func urlReceived(url: URL) {
        if let token = getTokenfromURL(url: url) {
            closeWebView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tokenSubject.send(token)
            }
        }
    }
}

extension AppliveryWebViewManager: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        tokenSubject.send(nil)
        safariViewController = nil
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
}
