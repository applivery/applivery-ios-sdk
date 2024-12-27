//
//  WebViewManager.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//


import SafariServices
import Combine

protocol AppliverySafariManagerProtocol {
    func openSafari(from url: URL, from viewController: UIViewController)
    var tokenPublisher: AnyPublisher<String?, Never> { get }
}

final class AppliverySafariManager: NSObject, AppliverySafariManagerProtocol {
    
    static let shared = AppliverySafariManager()
    
    private var safariViewController: SFSafariViewController?

    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    var tokenPublisher: AnyPublisher<String?, Never> {
        tokenSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
        
    // MARK: - Public Methods
    func openSafari(from url: URL, from viewController: UIViewController) {
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
        if let token = getTokenFromURL(url: url) {
            closeWebView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tokenSubject.send(token)
            }
        }
        closeWebView()
        
    }
    
    // MARK: - Private Helpers
    
    private func getTokenFromURL(url: URL) -> String? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let bearer = components.queryItems?.first(where: { $0.name == "bearer" })?.value
        else {
            return nil
        }
        return bearer
    }
    
}

// MARK: - SafariViewControllerDelegate
extension AppliverySafariManager: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        tokenSubject.send(nil)
    }
}
