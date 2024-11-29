//
//  ScreenshootViewModel.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import Foundation
import UIKit
import SwiftUI

enum ReportRequestState {
    case idle
    case success
    case failed
    case loading
    
    var title: String? {
        switch self {
        case .idle, .loading:
            nil
        case .success:
            "Feedback sended succesfully!"
        case .failed:
            "Feedback sended error"
        }
    }
}

final class ScreenshootViewModel: ObservableObject {
    
    @Published var isReportSended: ReportRequestState = .idle
    @Published var isAlertPresented: Bool = false
    
    private let feedbackService: PFeedbackService
    private let sessionPersister: SessionPersister
    
    init(
        feedbackService: PFeedbackService = FeedbackService(
            app: App(),
            device: Device(),
            config: GlobalConfig.shared
        ),
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard)
    ) {
        self.feedbackService = feedbackService
        self.sessionPersister = sessionPersister
    }
    
    @MainActor
    func sendScreenshootFeedback(feedback: Feedback) {
        isReportSended = .loading
        Task {
            do {
                try await feedbackService.postFeedback(feedback)
                self.isReportSended = .success
                self.isAlertPresented = true
                logInfo("Feedback sended succesfully")
            } catch {
                self.isReportSended = .failed
                self.isAlertPresented = true
                print("Feedback sended error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendVideoFeedback(feedback: Feedback) {
        isReportSended = .loading
        Task {
            do {
                try await feedbackService.postVideoFeedback(inputFeedback: feedback)
                self.isReportSended = .success
                self.isAlertPresented = true
                logInfo("Feedback sended succesfully")
            } catch {
                self.isReportSended = .failed
                self.isAlertPresented = true
                print("Feedback sended error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadUserName() -> String {
        return sessionPersister.loadUserName()
    }
    
    func exportDrawing(image: UIImage, lines: [Line]) -> UIImage? {
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()
        
        func toImagePoint(point: CGPoint) -> CGPoint {
            .init(x: point.x * image.size.width, y: point.y * image.size.height)
        }
        
        for line in lines {
            context?.setStrokeColor(line.color.cgColor ?? UIColor.systemPink.cgColor)
            context?.setLineWidth(line.lineWidth)
            
            var points = line.points
            if !points.isEmpty {
                let firstPoint = points.removeFirst()
                
                context?.move(to: toImagePoint(point: firstPoint))
                for point in points {
                    context?.addLine(to: toImagePoint(point: point))
                }
                context?.strokePath()
            }
        }
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage
    }
}
