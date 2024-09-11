//
//  ScreenRecorderManager.swift
//  Applivery
//
//  Created by Fran Alarza on 2/9/24.
//  Copyright © 2024 Applivery S.L. All rights reserved.
//

import Foundation
import ReplayKit
import SwiftUI

public final class ScreenRecorderManager: NSObject, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
    
    public static let shared = ScreenRecorderManager()
    
    private let recorder = RPScreenRecorder.shared()
    
    var isRecording = false
    private var isShowingSheet = false
    private var errorMessage: String?
    
    var recordViewController: RecordingViewController?
    
    init(recordViewController: RecordingViewController? = RecordingViewController(feedbackCoordinator: FeedbackCoordinator())) {
        super.init()
        self.recordViewController = recordViewController
        recorder.delegate = self
    }
    
    deinit {
        print("ShakeManager - deinit")
    }
    
    func startClipBuffering() {
        recorder.startClipBuffering { (error) in
            if error != nil {
                print("Error attempting to start Clip Buffering: \(error?.localizedDescription)")
            } else {
                self.isRecording = true
                self.recordViewController?.showRecordButton()
            }
        }
    }
    
    func exportClip() async {
        let clipURL = getDirectory()
        let interval = TimeInterval(15)
        
        print("Generating clip at URL: ", clipURL)
        do {
            try await recorder.exportClip(to: clipURL, duration: interval)
            self.isRecording = false
            
            presentVideoFeedback(clipURL: clipURL)
            logInfo("stopping the record")
            
        } catch {
            print("Error attempting to export Clip Buffering: \(error.localizedDescription)")
            
        }
    }
    
    func stopClipBuffering() {
        Task {
            do {
                await exportClip()
                try await recorder.stopClipBuffering()
                await self.recordViewController?.hideRecordButton()
            } catch {
                print("Error attempting to stop Clip Buffering: \(error.localizedDescription)")
            }
        }
    }
    
    func presentPreviewWithScreenshoot() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            
            guard let screenshot = takeScreenshotIncludingAlertBackground() else { return }
            
            if var topController = window.rootViewController {
                while let presentedController = topController.presentedViewController {
                    topController = presentedController
                }
                
                let view = ScreenshootPreviewScreen(screenshot: screenshot)
                let hosting = UIHostingController(rootView: view)
                hosting.modalPresentationStyle = .fullScreen
                topController.present(hosting, animated: true)
            }
        }
    }
    
    func presentVideoFeedback(clipURL: URL) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            
            if var topController = window.rootViewController {
                while let presentedController = topController.presentedViewController {
                    topController = presentedController
                }
                
                let previewVC = VideoPlayerViewController(videoURL: clipURL)
                previewVC.modalPresentationStyle = .fullScreen
                runOnMainThreadAsync {
                    topController.present(previewVC, animated: true)
                }
            }
        }
    }
}

private extension ScreenRecorderManager {
    func getDirectory() -> URL {
        var tempPath = URL(fileURLWithPath: NSTemporaryDirectory())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let stringDate = formatter.string(from: Date())
        print(stringDate)
        tempPath.appendPathComponent(String.localizedStringWithFormat("output-%@.mp4", stringDate))
        return tempPath
    }
    
    func takeScreenshotIncludingAlertBackground() -> UIImage? {
        if let window = UIApplication.shared.windows.first {
            let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
            return renderer.image { ctx in
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
        }
        return nil
    }
}

