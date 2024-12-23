//
//  WebViewManager.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//


import SafariServices
import Combine

protocol AppliverySafariManagerProtocol {
    func openSafari(from url: URL)
    var tokenPublisher: AnyPublisher<String?, Never> { get }
}

final class AppliverySafariManager: NSObject, AppliverySafariManagerProtocol {
    
    static let shared = AppliverySafariManager()
    
    private let windowPresenter: WindowPresentable

    private var safariViewController: SFSafariViewController?

    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    var tokenPublisher: AnyPublisher<String?, Never> {
        tokenSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(
        windowPresenter: WindowPresentable = WindowManager()
    ) {
        self.windowPresenter = windowPresenter
        super.init()
    }
    
    // MARK: - Public Methods
    func openSafari(from url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        windowPresenter.present(viewController: safariVC)
        safariViewController = safariVC
    }
    
    func urlReceived(url: URL) {
        guard let token = getTokenFromURL(url: url) else { return }
        
        removeWindow()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tokenSubject.send(token)
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
    
    private func removeWindow() {
        if let safariVC = safariViewController {
            windowPresenter.dismiss(viewController: safariVC)
        }
        safariViewController = nil
        windowPresenter.hide()
    }
}

// MARK: - SafariViewControllerDelegate
extension AppliverySafariManager: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        tokenSubject.send(nil)
        removeWindow()
    }
}
