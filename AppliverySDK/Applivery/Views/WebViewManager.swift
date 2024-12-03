//
//  WebViewManager.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//


import UIKit
@preconcurrency import WebKit

final class WebViewManager: NSObject {
    private var webView: WKWebView?
    
    func showWebView(url: URL) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            print("Unable to find key window")
            return
        }
        
        let webView = WKWebView(frame: window.bounds)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(webView)
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 16, y: 44, width: 60, height: 40)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        webView.addSubview(closeButton)
        
        self.webView = webView
    }
    
    @objc private func closeWebView() {
        webView?.removeFromSuperview()
        webView = nil
    }
}

extension WebViewManager: WKNavigationDelegate {
    // Called before navigation starts
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let newURL = navigationAction.request.url {
            print("Will navigate to URL: \(newURL)")
            // You can perform actions based on the new URL here
        }
        decisionHandler(.allow)  // Allow the navigation to proceed
    }
    
    // Called after navigation finishes
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url {
            print("Did finish navigating to URL: \(currentURL)")
            // You can perform actions based on the current URL here
        }
    }
}
