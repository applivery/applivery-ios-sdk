//
//  WindowManager.swift
//  Applivery
//
//  Created by Fran Alarza on 23/12/24.
//

import UIKit


protocol WindowPresentable: AnyObject {
    func present(viewController: UIViewController)
    func dismiss(viewController: UIViewController)
    func hide()
}

final class WindowManager: WindowPresentable {
    
    private var window: UIWindow?

    init() {}
    
    func present(viewController: UIViewController) {
        let hostingViewController = UIViewController()
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = hostingViewController
        newWindow.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        newWindow.makeKeyAndVisible()
        
        hostingViewController.present(viewController, animated: true)
        self.window = newWindow
    }
    
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
    
    func hide() {
        window?.isHidden = true
        window = nil
    }
}
