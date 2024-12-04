//
//  WebViewManager.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//


import UIKit
import Combine
@preconcurrency import WebKit

final class WebViewManager: NSObject {
    private var webView: WKWebView?
    private let app: AppProtocol
    
    init(webView: WKWebView? = nil, app: AppProtocol = App()) {
        self.webView = webView
        self.app = app
    }
    
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    var tokenPublisher: AnyPublisher<String?, Never> {
        return tokenSubject.eraseToAnyPublisher()
    }
    
    func showWebView(url: URL) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            print("Unable to find key window")
            return
        }
        
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: window.bounds, configuration: configuration)
        
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(webView)
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        self.webView = webView
    }
    
    func closeWebView() {
        logInfo("Closing web view..")
        webView?.removeFromSuperview()
        webView = nil
    }
}

extension WebViewManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let newURL = navigationAction.request.url {
            print("Will navigate to URL: \(newURL)")
            if newURL.absoluteString.contains("success") {
                getAuthToken(redirectUrl: newURL.absoluteString)
            } else {
                
            }
        }
        decisionHandler(.allow)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url {
            print("Did finish navigating to URL: \(currentURL)")
        }
    }
    
    func getAuthToken(redirectUrl: String) {
        if let urlComponents = URLComponents(string: redirectUrl),
           let queryItems = urlComponents.queryItems {
            if let bearerValue = queryItems.first(where: { $0.name == "bearer" })?.value {
                tokenSubject.send(bearerValue)
                logInfo("Auth success the bearer is: \(bearerValue)")
                closeWebView()
            } else {
                tokenSubject.send(nil)
            }
        }
    }
}
