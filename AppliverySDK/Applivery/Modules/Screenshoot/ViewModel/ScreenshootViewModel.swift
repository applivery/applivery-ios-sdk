//
//  ScreenshootViewModel.swift
//
//
//  Created by Fran Alarza on 11/9/24.
//

import Foundation
import UIKit
import SwiftUI

final class ScreenshootViewModel {
    
    private let feedbackService: PFeedbackService
    
    init(
        feedbackService: PFeedbackService = FeedbackService(
            app: App(),
            device: Device(),
            config: GlobalConfig.shared
        )
    ) {
        self.feedbackService = feedbackService
    }
    
    func sendScreenshootFeedback(feedback: Feedback) {
        feedbackService.postFeedback(feedback) { result in
            switch result {
            case .success(let successType):
                print("Feedback sended succesfully")
            case .error(let errorType):
                print("Feedback sended error:")
            }
        }
    }
    
    func exportDrawing(image: UIImage, lines: [Line]) -> UIImage {
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(image.size)
        
        // Draw the starting image in the current context as background
        image.draw(at: CGPoint.zero)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        func toImagePoint(point: CGPoint) -> CGPoint {
            .init(x: point.x * image.size.width, y: point.y * image.size.height)
        }
        
        for line in lines {
            context.setStrokeColor(line.color.cgColor ?? UIColor.systemPink.cgColor)
            context.setLineWidth(line.lineWidth)
            
            var points = line.points
            let firstPoint = points.removeFirst()
            
            context.move(to: toImagePoint(point: firstPoint))
            for point in points {
                context.addLine(to: toImagePoint(point: point))
            }
            context.strokePath()
        }
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
    }
}
