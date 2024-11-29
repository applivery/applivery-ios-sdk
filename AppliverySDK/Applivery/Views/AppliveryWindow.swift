//
//  AppliveryWindow.swift
//  
//
//  Created by Fran Alarza on 4/9/24.
//

import UIKit

class AppliveryWindow: UIWindow {
    
    private let shakeManager = ScreenRecorderManager.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rootViewController = shakeManager.recordViewController
        self.backgroundColor = .clear
        shakeManager.recordViewController?.buttonAction = {
            if self.shakeManager.isRecording {
                self.shakeManager.stopClipBuffering()
            } else {
                self.shakeManager.startClipBuffering()
            }
        }
    }
    
    deinit {
        print("window deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeKeyAndVisible() {
        super.makeKeyAndVisible()
        print("\(#function)")
    }
    
    override func makeKey() {
        super.makeKey()
        print("\(#function)")
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      var pointInside = false

        if let viewController = rootViewController as? RecordingViewController, viewController.shouldReceiveTouch(windowPoint: point) {
            pointInside = super.point(inside: point, with: event)
      }

      return pointInside
    }
    
}
