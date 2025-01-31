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
        logInfo("Opening Safari...")
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        safariVC.modalPresentationStyle = .fullScreen

        viewController.present(safariVC, animated: true, completion: nil)
        self.safariViewController = safariVC
    }
    
    func closeWebView(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.safariViewController?.dismiss(animated: true, completion: completion)
            self?.safariViewController = nil
        }
    }
    
    func urlReceived(url: URL) {
        if let token = getTokenFromURL(url: url) {
            closeWebView() { [weak self] in
                logInfo("Received token!")
                self?.tokenSubject.send(token)
            }
        } else {
            closeWebView()
        }
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
        closeWebView()
    }
}
