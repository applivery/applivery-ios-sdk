//
//  ShakeManager.swift
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
    
    func exportClip() async {
        let clipURL = getDirectory()
        let interval = TimeInterval(15)
        
        print("Generating clip at URL: ", clipURL)
        do {
            try await recorder.exportClip(to: clipURL, duration: interval)
            self.isRecording = false
            let previewVC = await VideoPlayerViewController(videoURL: clipURL)
            if let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = await windowScene.windows.first {
                let rootVC = await window.rootViewController
                await rootVC?.present(previewVC, animated: true)
            }
            logInfo("stopping the record")
            
        } catch {
            print("Error attempting to export Clip Buffering: \(error.localizedDescription)")
            
        }
    }
    
    func getDirectory() -> URL {
        var tempPath = URL(fileURLWithPath: NSTemporaryDirectory())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let stringDate = formatter.string(from: Date())
        print(stringDate)
        tempPath.appendPathComponent(String.localizedStringWithFormat("output-%@.mp4", stringDate))
        return tempPath
    }
}

