//
//  Recorder.swift
//  Applivery
//
//  Created by Fran Alarza on 2/9/24.
//  Copyright © 2024 Applivery S.L. All rights reserved.
//

import Foundation
import ReplayKit

final class Recorder: ObservableObject {
    let recorder = RPScreenRecorder.shared()
    
    @Published var isRecording = false
    @Published var errorMessage: String?
    
    func startRecording() {
        recorder.startRecording { [weak self] error in
            runOnMainThreadAsync {
                if let error {
                    self?.errorMessage = "Error to start record"
                    logInfo("Error to start record")
                } else {
                    self?.isRecording = true
                    logInfo("Record started")
                }
            }
        }
    }
    
    func stopRecording() {
        recorder.stopRecording { [weak self] previewVC, error in
            if let error {
                self?.errorMessage = "Error stopping the record \(error.localizedDescription)"
                logInfo("Error stopping the record \(error.localizedDescription)")
            } else {
                self?.isRecording = false
                if let previewVC = previewVC {
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                        logInfo("stopping the record")
                        rootVC.present(previewVC, animated: true, completion: nil)
                    } else {
                        logInfo("Error")
                    }
                } else {
                    logInfo("Error")
                }
                self?.errorMessage = "stopping the record"
                logInfo("stopping the record")
            }
        }
    }
}
