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
    private var timer: Timer?
    
    var isRecording = false
    private var isShowingSheet = false
    private var errorMessage: String?
    
    var recordViewController: RecordingViewController?
    
    init(
        recordViewController: RecordingViewController? = RecordingViewController(),
        timer: Timer? = nil
    ) {
        super.init()
        self.recordViewController = recordViewController
        self.timer = timer
        recorder.delegate = self
    }
    
    deinit {
        print("ShakeManager - deinit")
    }
    
    func startClipBuffering() {
        recorder.startClipBuffering { [weak self] (error) in
            if error != nil {
                print("Error attempting to start Clip Buffering: \(String(describing: error?.localizedDescription))")
            } else {
                self?.isRecording = true
                self?.setTimer()
                self?.recordViewController?.showRecordButton()
            }
        }
    }
    
    func exportClip() async {
        let clipURL = getDirectory()
        let interval = TimeInterval(30)
        
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
                self.timer?.invalidate()
                self.timer = nil
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
                
                DispatchQueue.main.async {
                    let view = ScreenshootPreviewScreen(screenshot: screenshot)
                    let hosting = UIHostingController(rootView: view)
                    hosting.modalPresentationStyle = .overFullScreen
                    topController.present(hosting, animated: true)
                }
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
                
                DispatchQueue.main.async {
                    let view = VideoPreviewScreen(url: clipURL)
                    let hosting = UIHostingController(rootView: view)
                    hosting.modalPresentationStyle = .overFullScreen
                    topController.present(hosting, animated: true)
                }
            }
        }
    }
    
    func setTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { [weak self] _ in
            self?.stopClipBuffering()
        })
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

