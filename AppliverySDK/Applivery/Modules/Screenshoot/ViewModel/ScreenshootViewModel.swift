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
    
    func saveDrawing(image: UIImage, lines: [Line]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        image.draw(at: .zero)
        
        for line in lines {
            context.setStrokeColor(line.color.cgColor ?? CGColor(red: 1, green: 1, blue: 1, alpha: 1))
            context.setLineWidth(line.lineWith)
            context.setLineCap(.round)
            
            let cgPath = line.path.cgPath
            
            context.addPath(cgPath)
            context.drawPath(using: .fillStroke)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return newImage
    }
}
